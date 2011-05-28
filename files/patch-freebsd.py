--- pypy/translator/platform/freebsd.py~	2011-04-30 16:18:50.000000000 +0200
+++ pypy/translator/platform/freebsd.py	2011-05-25 17:33:44.000000000 +0200
@@ -18,8 +18,8 @@
 class Freebsd(posix.BasePosix):
     name = "freebsd"
 
-    link_flags = get_env_vector("LDFLAGS", '-pthread')
-    cflags = get_env_vector("CFLAGS", "-O3 -pthread -fomit-frame-pointer")
+    link_flags = get_env_vector("LDFLAGS", '-pthread') + ["-L" + os.path.join(get_env("LOCALBASE", "/usr/local"), "lib")]
+    cflags = get_env_vector("CFLAGS", "-O3 -pthread -fomit-frame-pointer") + ["-I" + os.path.join(get_env("LOCALBASE", "/usr/local"), "include")]
     standalone_only = []
     shared_only = []
     so_ext = 'so'
@@ -32,15 +32,6 @@
 
     def _args_for_shared(self, args):
         return ['-shared'] + args
-
-    def _preprocess_include_dirs(self, include_dirs):
-        res_incl_dirs = list(include_dirs)
-        res_incl_dirs.append(os.path.join(get_env("LOCALBASE", "/usr/local"), "include"))
-        return res_incl_dirs
-
-    def _preprocess_library_dirs(self, library_dirs):
-        res_lib_dirs = list(library_dirs)
-        res_lib_dirs.append(os.path.join(get_env("LOCALBASE", "/usr/local"), "lib"))
         return res_lib_dirs
 
     def _include_dirs_for_libffi(self):
