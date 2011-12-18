# PyPy instances
# See http://readthedocs.org/docs/pypy/latest/config/index.html for a list of
# options available.  --gcrootfinder=asmgcc does not work under FreeBSD/amd64.

PYPY_DEFAULT_NAME?=		pypy
PYPY_DEFAULT_TRANSLATE_ARGS?=
PYPY_DEFAULT_OPT?=		jit
PYPY_DEFAULT_OBJSPACE_ARGS?=

PYPY_SANDBOX_NAME?=		pypy-sandbox
PYPY_SANDBOX_TRANSLATE_ARGS?=	--sandbox
PYPY_SANDBOX_OPT?=		jit
PYPY_SANDBOX_OBJSPACE_ARGS?=

# Currently does not work
PYPY_CLI_NAME?=			pypy-cli
PYPY_CLI_TRANSLATE_ARGS?=	--backend=cli
PYPY_CLI_OPT?=			2
PYPY_CLI_OBJSPACE_ARGS?=
