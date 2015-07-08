python
import sys
import os
sys.path.insert(0, os.path.expanduser('~/.gdbd/'))
for gcc_dir in os.listdir('/usr/share/'):
  if gcc_dir.startswith('gcc-'):
    sys.path.insert(0, '/usr/share/%s/python' % (gcc_dir,))
    print('load pretty_print of %s'  % (gcc_dir,))
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end

#
# C++ related beautifiers (optional)
#

set print pretty on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set demangle-style gnu-v3
set print sevenbit-strings off
# source ~/peda/peda.py
