import sys, math, random

#The Zipf class is from Kamaelia:
################################################################################################
# Copyright (C) 2004 British Broadcasting Corporation and Kamaelia Contributors(1)
#     All Rights Reserved.
#
# You may only modify and redistribute this under the terms of any of the
# following licenses(2): Mozilla Public License, V1.1, GNU General
# Public License, V2.0, GNU Lesser General Public License, V2.1
#
# (1) Kamaelia Contributors are listed in the AUTHORS file and at
#     http://kamaelia.sourceforge.net/AUTHORS - please extend this file,
#     not this notice.
# (2) Reproduced in the COPYING file, and at:
#     http://kamaelia.sourceforge.net/COPYING
# Under section 3.5 of the MPL, we are using this text since we deem the MPL
# notice inappropriate for this file. As per MPL/GPL/LGPL removal of this
# notice is prohibited.
class zipf:
   """Zipf distribution generator.
   * The algorithm here is directly adapted from:
   * http://www.cs.hut.fi/Opinnot/T-106.290/K2004/Ohjeet/Zipf.html

   N # Value range [1,N]
   a  # Distribution skew. Zero = uniform.
   c1,c2 # Computed once for all random no.s for N and a
   """
   def __init__(self,N=10000,a=1):
      self.N = N
      if a < 0.0001:
         self.a = 0.0
         self.c1 = 0.0
         self.c2 = 0.0
      elif 0.9999 <a < 1.0001:
         self.a = 1.0
         self.c1 = math.log(N+1)
         self.c2 = 0.0
      else:
         self.a = float(a)
         self.c1 = math.exp((1-a) * math.log(N+1)) - 1
         self.c2 = 1.0 / (1-a)

   def __repr__(self):
      return "zipf( " + str(self.N) + ", " + str(self.a) + ") : " + str(self.c1) + ", " + str(self.c2)

   def next(self):
      r = 0
      x = 0.0
      if self.a == 0:
         return random.randint(1,self.N)
      while r <= 1 or r>self.N:
         x = random.random()
         if self.a == 1:
            x = math.exp(x * self.c1);
         else:
            x = math.exp(self.c2 * math.log(x * self.c1 + 1));
         r=int(x)
      return r
################################################################################################
