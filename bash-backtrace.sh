# Add python-like backtraces to your bash shell scripts!
#
# Use like so:
#
# #!/bin/bash
# set -eu
# source "$stripe_random/bash-backtrace.sh"
# ...
#
# If you're using this, chances are high that you should switch from bash to a
# more modern programming language.
#

# Copyright (c) 2014- Stripe, Inc. (https://stripe.com)
#
# bash-backtrace.sh is published under the MIT license:
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#


if [ -z "${BASH_VERSION-}" ]; then
    echo >&2 "Error: this script only works in bash"
    return 1 || exit 1
fi

set -E

# References:
# - https://gist.github.com/ryo1kato/3102982
# - https://gist.github.com/kergoth/6395873

bash_backtrace() {
    local ret=$?
    local i=0
    local FRAMES=${#BASH_SOURCE[@]}


    echo >&2 "Traceback (most recent call last):"

    for ((frame=FRAMES-2; frame >= 0; frame--)); do
        local lineno=${BASH_LINENO[frame]}

        printf >&2 '  File "%s", line %d, in %s\n' \
            "${BASH_SOURCE[frame+1]}" "$lineno" "${FUNCNAME[frame+1]}"

        sed >&2 -n "${lineno}s/^[   ]*/    /p" "${BASH_SOURCE[frame+1]}"
    done

    printf >&2 "Exiting with status %d\n" "$ret"
}

trap bash_backtrace ERR
