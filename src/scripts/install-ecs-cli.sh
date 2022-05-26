if [ $EUID == 0 ]; then export SUDO=""; else export SUDO="sudo"; fi

# Platform check
if uname -a | grep "Darwin"; then
    export SYS_ENV_PLATFORM="darwin"
elif uname -a | grep "Linux"; then
    export SYS_ENV_PLATFORM="linux"
else
    echo "This platform appears to be unsupported."
    uname -a
    exit 1
fi


$SUDO curl -Lo "${ECS_PARAM_INSTALL_DIR}" "https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-${SYS_ENV_PLATFORM}-amd64-${ECS_PARAM_VERSION}"

$SUDO chmod +x "${ECS_PARAM_INSTALL_DIR}"

if [ "$(ecs-cli --version > /dev/null 2>&1; echo $?)" -eq 0 ]; then
    echo "ecs-cli installed successfully."
else
    echo "ecs-cli installation failed."
    exit 1
fi
