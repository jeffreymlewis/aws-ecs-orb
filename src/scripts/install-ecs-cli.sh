if [ $EUID == 0 ]; then export SUDO=""; else export SUDO="sudo"; fi

# Platform check
if uname -a | grep "Darwin"; then
    export SYS_ENV_PLATFORM="darwin"
elif uname -a | grep "x86_64 GNU/Linux"; then
    export SYS_ENV_PLATFORM="linux"
else
    echo "This platform appears to be unsupported."
    uname -a
    exit 1
fi


Install_ECS_CLI(){
    $SUDO curl -Lo "${ECS_PARAM_INSTALL_DIR}" "https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-${SYS_ENV_PLATFORM}-amd64-$1"
    $SUDO chmod +x "${ECS_PARAM_INSTALL_DIR}"
}

Uninstall_ECS_CLI(){
    #shellcheck disable=SC2230
    ECS_CLI_PATH="$(which ecs-cli)"
    $SUDO rm -rf "${ECS_CLI_PATH}"
}

if [ "$(ecs-cli --version > /dev/null; echo $?)" -ne 0 ]; then
    Uninstall_ECS_CLI
    echo "Installing ECS CLI..."
    Install_ECS_CLI "${ECS_PARAM_VERSION}"
    ecs-cli --version
else
    if [ "$ECS_PARAM_OVERRIDE_INSTALLED" = 1 ]; then
        echo "Overriding installed ECS CLI..."
        Uninstall_ECS_CLI
        Install_ECS_CLI "${ECS_PARAM_VERSION}"
        ecs-cli --version
    fi
    echo "ECS CLI is already installed."
fi

