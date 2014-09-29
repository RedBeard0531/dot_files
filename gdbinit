handle SIGSTOP noprint

python
import sys
import os
try:
    sys.path.insert(0, os.path.expanduser('~/opensource/gdb-stl/'))
    from libstdcxx.v6.printers import register_libstdcxx_printers
    register_libstdcxx_printers (None)
except Exception:
    print "STL helpers unavailable. Check out svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python"
    pass

try:
    sys.path.insert(0, os.path.expanduser('~/opensource/Boost-Pretty-Printer/'))
    from boost.printers import register_printer_gen
    register_printer_gen(None)
except Exception:
    print "Boost helpers unavailable. Check out https://github.com/ruediger/Boost-Pretty-Printer"
    pass

try:
    sys.path.insert(0, os.path.expanduser('~/10gen/mongo_gdb/'))
    import mongo_printer
    mongo_printer.register_mongo_printers()
except Exception:
    print "Error loading mongo_printer"
    pass
end

set print pretty on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set demangle-style gnu-v3
set print sevenbit-strings off
set print static-members off
set pagination off
set history filename ~/.gdb_history
set history save

set print asm-demangle on

