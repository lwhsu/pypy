# New ports collection makefile for:	pypy
# Date created:				2011/05/17
# Whom:					David Naylor <naylor.b.david@gmail.com>
#
# $FreeBSD$
#

PORTNAME=	pypy
DISTVERSION=	1.5
CATEGORIES=	lang python
MASTER_SITES=	http://pypy.org/download
DISTNAME=	${PORTNAME}-${DISTVERSION}-src

MAINTAINER=	naylor.b.david@gmail.com
COMMENT=	PyPy is a fast, compliant implementation of the Python language

#LICENSE=	
USE_BZIP2=	yes

.include <bsd.port.mk>
