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

import java.io.BufferedOutputStream;
import java.io.FileDescriptor;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.lang.management.ManagementFactory;
import java.net.*;
import java.util.*;
import java.util.logging.ConsoleHandler;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Map.Entry;

import joptsimple.OptionParser;
import joptsimple.OptionSet;

import com.yarnlocaltop.VMOfflineView;

import sun.jvmstat.monitor.*;

public class YarnLocalTop
{
  public static final String                         VERSION                 = "1.0.0";
  private Double                                     delay_                  = 1.0;
  private Boolean                                    supportsSystemAverage_;
  private java.lang.management.OperatingSystemMXBean localOSBean_;
  private int                                        maxIterations_          = -1;
  private static Logger                              logger;

  private static OptionParser createOptionParser()
  {
    OptionParser parser = new OptionParser();
    parser.acceptsAll(Arrays.asList(new String[] { "help", "?", "h" }),
        "shows this help").forHelp();
    parser
        .acceptsAll(Arrays.asList(new String[] { "n", "iteration" }),
            "yarnlocaltop will exit after n output iterations").withRequiredArg()
        .ofType(Integer.class);
    parser
        .acceptsAll(Arrays.asList(new String[] { "d", "delay" }),
            "delay between each output iteration").withRequiredArg()
        .ofType(Double.class);
    parser.accepts("threadlimit",
        "sets the number of displayed threads in detail mode")
        .withRequiredArg().ofType(Integer.class);
    parser
        .acceptsAll(Arrays.asList(new String[] { "p", "pid" }),
            "Connect to only this PID").withRequiredArg().ofType(Integer.class);
    return parser;
  }

  public static void main(String[] args) throws Exception
  {
    Locale.setDefault(Locale.US);

    logger = Logger.getLogger("yarnlocaltop");

    OptionParser parser = createOptionParser();
    OptionSet a = parser.parse(args);

    if (a.has("help"))
    {
      System.out.println("yarnlocaltop - yarn monitoring for the command-line");
      System.out.println("Usage: yarnlocaltop.sh [options...] [PID]");
      System.out.println("");
      parser.printHelpOn(System.out);
      System.exit(0);
    }
    boolean sysInfoOption = a.has("sysinfo");

    Integer pid = null;
    double delay = 1.0;
    Integer iterations = -1;
    Integer threadlimit = null;
    boolean threadLimitEnabled = true;
    boolean offlineMode = a.has("offline");
    if (a.hasArgument("delay"))
    {
      delay = (Double) (a.valueOf("delay"));
      if (delay < 0.1d)
      {
        throw new IllegalArgumentException("Delay cannot be set below 0.1");
      }
    }
    if (a.hasArgument("n"))
    {
      iterations = (Integer) a.valueOf("n");
    }

    //to support PID as non option argument
    if (a.nonOptionArguments().size() > 0)
    {
      pid = Integer.valueOf((String) a.nonOptionArguments().get(0));
    }
    if (a.hasArgument("pid"))
    {
      pid = (Integer) a.valueOf("pid");
    }

    if (a.hasArgument("threadlimit"))
    {
      threadlimit = (Integer) a.valueOf("threadlimit");
    }

    YarnLocalTop top = new YarnLocalTop();
    top.setDelay(delay);
    top.setMaxIterations(iterations);
    top.run();
  }

  private void updateInfoList(List<VMInfo> vmInfoList, Map<Integer, LocalVirtualMachine> oldMachines, Map<Integer, LocalVirtualMachine> newMachines)
  {
    Set<Entry<Integer, LocalVirtualMachine>> set = newMachines.entrySet();
    for (Entry<Integer, LocalVirtualMachine> entry : set)
    {
      LocalVirtualMachine localvm = entry.getValue();
      int vmid = localvm.vmid();

      if (!oldMachines.containsKey(vmid))
      {
        VMInfo vmInfo = VMInfo.processNewVM(localvm, vmid);
        vmInfoList.add(vmInfo);
      }
    }
  }

  private Map<Integer, LocalVirtualMachine> scanForNewVMs(Map<Integer, LocalVirtualMachine> vmMap)
  {
    Map<Integer, LocalVirtualMachine> machines = LocalVirtualMachine.getNewVirtualMachines(vmMap);
    return machines;
  }

  private void updateVMs(List<VMInfo> vmList) throws Exception
  {
    for (VMInfo vmInfo : vmList)
    {
      vmInfo.update();
    }
  }

  // XXX: Retire this
  public ArrayList<Integer> getYarnPids()
  {
    ArrayList<Integer> pids = new ArrayList<Integer>();

    try {
      HostIdentifier hostId = new HostIdentifier((String)null);
      MonitoredHost monitoredHost = MonitoredHost.getMonitoredHost(hostId);
      Set jvms = monitoredHost.activeVms();

      for (Iterator j = jvms.iterator(); j.hasNext(); /* empty */ ) {
        StringBuilder output = new StringBuilder();
        Throwable lastError = null;

        // The PID
        Integer lvmid = (Integer)j.next();

        // Figure out the class name.
        MonitoredVm vm = null;
        String vmidString = "//" + lvmid + "?mode=r";
        try {
          VmIdentifier id = new VmIdentifier(vmidString);
          vm = monitoredHost.getMonitoredVm(id, 0);
        } catch (URISyntaxException e) {
          // unexpected as vmidString is based on a validated hostid
          e.printStackTrace();
        } catch (MonitorException e) {
          // Process exited but PID is still being returned.
        } catch (Exception e) {
          e.printStackTrace();
        } finally {
          if (vm == null) {
            continue;
          }
        }

        // See if we want this JVM.
        // We should have a list of YARN process types worth attaching to.
        String className = MonitoredVmUtil.mainClass(vm, false);
        if (className.equals("TezChild") || className.equals("YarnChild")) {
          pids.add(lvmid);
        }

        monitoredHost.detach(vm);
      }
    } catch (Exception e) {
      if (e.getMessage() != null) {
        System.err.println(e.getMessage());
      } else {
        Throwable cause = e.getCause();
        if ((cause != null) && (cause.getMessage() != null)) {
          System.err.println(cause.getMessage());
        } else {
          e.printStackTrace();
        }
      }
    }

    return pids;
  }

  public int getMaxIterations()
  {
    return maxIterations_;
  }

  public void setMaxIterations(int iterations)
  {
    maxIterations_ = iterations;
  }

  private static void fineLogging()
  {
    //get the top Logger:
    Logger topLogger = java.util.logging.Logger.getLogger("");

    // Handler for console (reuse it if it already exists)
    Handler consoleHandler = null;
    //see if there is already a console handler
    for (Handler handler : topLogger.getHandlers())
    {
      if (handler instanceof ConsoleHandler)
      {
        //found the console handler
        consoleHandler = handler;
        break;
      }
    }

    if (consoleHandler == null)
    {
      //there was no console handler found, create a new one
      consoleHandler = new ConsoleHandler();
      topLogger.addHandler(consoleHandler);
    }
    //set the console handler to fine:
    consoleHandler.setLevel(java.util.logging.Level.FINEST);
  }

  protected void run() throws Exception
  {
    try
    {
      HashMap<Integer, VMOfflineView> map = new HashMap<Integer, VMOfflineView>();
      List<VMInfo> vmInfoList = new ArrayList<VMInfo>();
      Map<Integer, LocalVirtualMachine> oldVmMap = new HashMap<Integer, LocalVirtualMachine>();
      Map<Integer, LocalVirtualMachine> newVmMap = new HashMap<Integer, LocalVirtualMachine>();

      int iterations = 0;
      int pidCheckStep = 5;

      while (iterations < maxIterations_ || maxIterations_ < 0) {
        // Refresh the view list every pidCheckStep intervals.
        if (iterations % pidCheckStep == 0) {
/*
          newVmMap = scanForNewVMs(oldVmMap);
          vmInfoList = updateInfoList(oldVmMap, newVmMap);
          updateVMs(vmInfoList);
          oldVmMap = newVmMap;
*/

          // Delete anything that should exit.
          for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
            Map.Entry pair = (Map.Entry)iterator.next();
            VMOfflineView view = (VMOfflineView)pair.getValue();
            if (view.shouldExit()) {
              iterator.remove();
            }
          }
          // Look for new additions.
          ArrayList<Integer> pids = getYarnPids();
          for (Integer i : pids) {
            if (map.get(i) == null) {
              VMOfflineView view = new VMOfflineView(i);
              map.put(i, view);
            }
          }

          if (map.size() == 0) {
            System.out.println("No YARN containers detected (are you running as yarn?)");
          }
        }

        // Update each active view
        for (VMOfflineView view : map.values()) {
          if (!view.shouldExit()) {
            view.printView();
          }
        }

        iterations++;
        Thread.sleep((int) (delay_ * 1000));
      }
    }
    catch (NoClassDefFoundError e)
    {
      e.printStackTrace(System.err);

      System.err.println("");
      System.err.println("ERROR: Some JDK classes cannot be found.");
      System.err
          .println("       Please check if the JAVA_HOME environment variable has been set to a JDK path.");
      System.err.println("");
    }
  }

  public YarnLocalTop()
  {
    localOSBean_ = ManagementFactory.getOperatingSystemMXBean();
  }

  public Double getDelay()
  {
    return delay_;
  }

  public void setDelay(Double delay)
  {
    delay_ = delay;
  }
}
