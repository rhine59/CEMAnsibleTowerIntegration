SERVER1=($(curl -sS --request GET https://foo/bar| awk 'BEGIN {FS="["} {print $1}'))
SERVER2=($(curl -sS --request GET https://foo/bar| awk 'BEGIN {FS="["} {print $2}'))
SERVER3=($(curl -sS --request GET https://foo/bar| awk 'BEGIN {FS="["} {print $3}'))

cat <<EOF
{
    "test1": {
        "hosts": ["$SERVER1"],
    },
    "test2": {
        "hosts": ["$SERVER2"],
    },
    "test3": {
        "hosts": ["$SERVER3"],
    }
}
EOF
