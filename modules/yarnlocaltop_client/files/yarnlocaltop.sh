#!/bin/sh
# yarnlocaltop - run it as the YARN user
DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

if [ -z "$JAVA_HOME" ] ; then
        JAVA_HOME=`readlink -f \`which java 2>/dev/null\` 2>/dev/null | \
        sed 's/\/bin\/java//'`
fi

TOOLSJAR="$JAVA_HOME/lib/tools.jar"

if [ ! -f "$TOOLSJAR" ] ; then
        echo "$JAVA_HOME seems to be no JDK!" >&2
        exit 1
fi

"$JAVA_HOME"/bin/java $JAVA_OPTS -cp "$DIR/yarnlocaltop.jar:$TOOLSJAR" com.yarnlocaltop.YarnLocalTop "$@"
exit $?
