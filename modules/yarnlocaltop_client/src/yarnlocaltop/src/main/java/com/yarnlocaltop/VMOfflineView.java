/**
 * Copyright (C) 2013 by Patric Rufflar. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

package com.yarnlocaltop;

import java.lang.StackTraceElement;
import java.lang.management.ThreadInfo;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import com.yarnlocaltop.VMInfo;
import com.yarnlocaltop.VMInfoState;
import com.yarnlocaltop.LocalVirtualMachine;

/**
 * "detail" view, but streamed out for later offline analysis.
 */
public class VMOfflineView extends AbstractConsoleView
{
  private VMInfo          vmInfo_;
  private int             numberOfDisplayedThreads_ = 16;
  private double          minUtilization_           = 10d;
  private boolean         displayedThreadLimit_     = true;
  private boolean         headerDisplayed_          = false;
  private int             pid_;

  private Map<Long, Long> previousThreadCPUMillis   = new HashMap<Long, Long>();

  public VMOfflineView(int vmid) throws Exception
  {
    super(100);
    pid_ = vmid;
    LocalVirtualMachine localVirtualMachine = LocalVirtualMachine
        .getLocalVirtualMachine(vmid);
    vmInfo_ = VMInfo.processNewVM(localVirtualMachine, vmid);
  }

  @Override
  public void printView() throws Exception
  {
    vmInfo_.update();

    if (vmInfo_.getState() == VMInfoState.ATTACHED_UPDATE_ERROR)
    {
      System.out
          .println("ERROR: Could not fetch telemetries - Process terminated?");
      exit();
      return;
    }
    if (vmInfo_.getState() != VMInfoState.ATTACHED)
    {
      System.out.println("ERROR: Could not attach to process.");
      exit();
      return;
    }

    Map<String, String> properties = vmInfo_.getSystemProperties();

    if (!headerDisplayed_) {
      headerDisplayed_ = true;

      String command = properties.get("sun.java.command");
      if (command != null)
      {
        String[] commandArray = command.split(" ");

        List<String> commandList = Arrays.asList(commandArray);
        commandList = commandList.subList(1, commandList.size());

        System.out.printf("PID %d: %s %n", vmInfo_.getId(), commandArray[0]);

        String argJoin = join(commandList, " ");
        System.out.printf("ARGS: %s%n", argJoin);
      }
      else
      {
        System.out.printf("PID %d: %n", vmInfo_.getId());
        System.out.printf("ARGS: [UNKNOWN] %n");
      }

      String join = join(vmInfo_.getRuntimeMXBean().getInputArguments(), " ");
      System.out.printf("VMARGS: %s%n", join);

      System.out.printf("VM: %s %s %s%n", properties.get("java.vendor"),
          properties.get("java.vm.name"), properties.get("java.version"));
    }

    System.out.printf(
        "PID:%d CPU:%.2f%% GC:%.2f%% HEAP:%s/%s NONHEAP:%s/%s UP:%s " +
        "#THR:%d #THRPEAK:%d #THRCREATED:%d GCTIME:%s GCRUNS:%d CLASSES:%d%n",
        pid_, vmInfo_.getCpuLoad() * 100, vmInfo_.getGcLoad()*100,
        toMB(vmInfo_.getHeapUsed()), toMB(vmInfo_.getHeapMax()),
        toMB(vmInfo_.getNonHeapUsed()), toMB(vmInfo_.getNonHeapMax()),
        toHHMM(vmInfo_.getRuntimeMXBean().getUptime()), vmInfo_.getThreadCount(),
        vmInfo_.getThreadMXBean().getPeakThreadCount(),
        vmInfo_.getThreadMXBean().getTotalStartedThreadCount(),
        toHHMM(vmInfo_.getGcTime()), vmInfo_.getGcCount(),
        vmInfo_.getTotalLoadedClassCount());

    try {
      printTopThreads();
    } catch (Exception e) {
      exit();
      return;
    }
  }

  /**
   * @throws Exception
   */
  private void printTopThreads() throws Exception
  {
    if (vmInfo_.getThreadMXBean().isThreadCpuTimeSupported())
    {
      Map<Long, Long> newThreadCPUMillis = new HashMap<Long, Long>();
      Map<Long, Long> cpuTimeMap = new TreeMap<Long, Long>();

      for (Long tid : vmInfo_.getThreadMXBean().getAllThreadIds())
      {
        long threadCpuTime = vmInfo_.getThreadMXBean().getThreadCpuTime(tid);
        long deltaThreadCpuTime = 0;
        if (previousThreadCPUMillis.containsKey(tid))
        {
          deltaThreadCpuTime = threadCpuTime - previousThreadCPUMillis.get(tid);
          cpuTimeMap.put(tid, deltaThreadCpuTime);
        }
        newThreadCPUMillis.put(tid, threadCpuTime);
      }

      cpuTimeMap = sortByValue(cpuTimeMap, true);
      String timeStamp = new SimpleDateFormat("HH:mm:ss.SSS").format(new Date());

      int displayedThreads = 0;
      for (Long tid : cpuTimeMap.keySet())
      {
        ThreadInfo info = vmInfo_.getThreadMXBean().getThreadInfo(tid, 50);
        displayedThreads++;
        if (displayedThreads > numberOfDisplayedThreads_)
        {
          break;
        }
        double currentUtilization = getThreadCPUUtilization(cpuTimeMap.get(tid), vmInfo_.getDeltaUptime());
        if (info != null && currentUtilization > minUtilization_ && !info.getThreadName().startsWith("RMI TCP Connection"))
        {
          System.out.printf("%s,%s,%d,%5.2f%%,%d,%s\n",
              timeStamp,
              info.getThreadName(),
              pid_,
              currentUtilization,
              info.getBlockedCount(),
              info.isInNative()
          );

          StackTraceElement[] trace = info.getStackTrace();
          for (StackTraceElement t : trace) {
            System.out.printf(" %s,%s.%s(%d)\n",
                info.getThreadName(),
                t.getClassName(),
                t.getMethodName(),
                t.getLineNumber()
            );
          }
        }
      }
      previousThreadCPUMillis = newThreadCPUMillis;
    }
    else
    {
      System.out.printf("Thread CPU telemetries are not available on the monitored jvm/platform");
    }
  }

  private String getBlockedThread(ThreadInfo info)
  {
    if (info.getLockOwnerId() >= 0)
    {
      return "" + info.getLockOwnerId();
    }
    else
    {
      return "";
    }
  }

  private double getThreadCPUUtilization(long deltaThreadCpuTime, long totalTime)
  {
    return getThreadCPUUtilization(deltaThreadCpuTime, totalTime, 1000 * 1000);
  }

  private double getThreadCPUUtilization(long deltaThreadCpuTime,
      long totalTime, double factor)
  {
    if (totalTime == 0)
    {
      return 0;
    }
    return deltaThreadCpuTime / factor / totalTime * 100d;
  }

  public int getPid()
  {
    return pid_;
  }
}
