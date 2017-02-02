#handle SIGSTOP noprint

python
import sys
import os
#try:
    #sys.path.insert(0, os.path.expanduser('~/opensource/gdb-stl/'))
    #from libstdcxx.v6.printers import register_libstdcxx_printers
    #register_libstdcxx_printers (None)
#except Exception as e:
    #print( "STL helpers unavailable. Check out svn co svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python" )
    #print(e)
    #pass

try:
    sys.path.insert(0, os.path.expanduser('~/opensource/Boost-Pretty-Printer/'))
    import boost.latest
    boost.register_printers()
except Exception:
    print( "Boost helpers unavailable. Check out https://github.com/mateidavid/Boost-Pretty-Printer" )
    pass

#try:
    #sys.path.insert(0, os.path.expanduser('~/10gen/mongo_gdb/'))
    #import mongo_printer
    #mongo_printer.register_mongo_printers()
#except Exception:
    #print( "Error loading mongo_printer. Check out https://github.com/RedBeard0531/mongo_gdb" )
    #pass
end

add-auto-load-safe-path /home/mstearn/10gen/mongo/.gdbinit

set print pretty on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set demangle-style auto
set print sevenbit-strings off
set print static-members off
set pagination off
set history filename ~/.gdb_history
set history save

set print asm-demangle on
set disassembly-flavor intel

