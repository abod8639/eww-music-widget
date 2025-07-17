#!/bin/bash
cava -p <(cat <<EOF
[general]
bars = 27
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 6
EOF
) | sed -u 's/;//g;s/0/▂/g;s/1/▃/g;s/2/▄/g;s/3/▅/g;s/4/▆/g;s/5/▇/g;s/6/█/g;'
