name = "i3_gaps"

version = "4.18.1"


@late()
def tools():
    import os

    bin_path = os.path.join(str(this.root), "bin")
    executables = []
    for item in os.listdir(bin_path):
        path = os.path.join(bin_path, item)
        if os.access(path, os.X_OK) and not os.path.isdir(path):
            executables.append(item)
    return executables


build_command = r"""
set -euf -o pipefail

IIDFILE=$(mktemp "$REZ_BUILD_PATH"/DockerImageXXXXX)
cp -v "$REZ_BUILD_SOURCE_PATH"/entrypoint.sh \
    "$REZ_BUILD_SOURCE_PATH"/Dockerfile \
    "$REZ_BUILD_PATH"
docker build --rm --iidfile "$IIDFILE" "$REZ_BUILD_PATH"

CONTAINER_ARGS=()
[ -t 1 ] && CONTAINER_ARGS+=("-it") || :
CONTAINER_ARGS+=("--env" "INSTALL_DIR={install_dir}")
CONTAINER_ARGS+=("--env" "VERSION={version}")
CONTAINER_ARGS+=("--env" "XCB_UTIL_XRM_TAG=v1.3")
CONTAINER_ARGS+=("--env" "I3_STATUS_TAG=2.12")
CONTAINER_ARGS+=("$(cat $IIDFILE)")


if [ $REZ_BUILD_INSTALL -eq 1 ]
then
    CONTAINTER_ID=$(docker create "{CONTAINER_ARGS}")
    docker start -ia "$CONTAINTER_ID"
    docker cp "$CONTAINTER_ID":"{install_dir}"/. "{install_dir}"
    docker rm "$CONTAINTER_ID"
    echo "Please run: sudo yum install '{install_dir}/etc/i3/deps'/*.rpm"
fi
""".format(
    CONTAINER_ARGS="${{CONTAINER_ARGS[@]}}",
    install_dir="${{REZ_BUILD_INSTALL_PATH:-/usr/local}}",
    version=version,
)


def commands():
    import os.path

    env.PATH.append(os.path.join("{root}", "bin"))
    env.LD_LIBRARY_PATH.append(os.path.join("{root}", "lib"))
    env.XDG_DATA_DIRS.append(os.path.join("{root}", "share"))
