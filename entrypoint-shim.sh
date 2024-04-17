#!/usr/bin/env bash

args=("$@")

# Declare a map of any potential wrapper arguments to be passed into Ignition upon startup
declare -A wrapper_args_map=( 
    ["-Dignition.projects.scanFrequency"]=${PROJECT_SCAN_FREQUENCY:-10}  # Disable console logging
)

# Declare a map of potential jvm arguments to be passed into Ignition upon startup, before the wrapper args
declare -A jvm_args_map=()

main() {  
    # Create the data folder for Ignition for any upcoming symlinks
    mkdir -p "${IGNITION_INSTALL_LOCATION}"/data

    seed_preloaded_contents

     # Create the symlink for the projects folder if enabled
    if [ "$SYMLINK_PROJECTS" = "true" ]; then
        symlink_projects
    fi

    # If there are any modules mapped into the /modules directory, copy them to the user lib
    if [ -d "/modules" ]; then
        copy_modules_to_user_lib
    fi

	# If developer mode is enabled, add the developer mode wrapper arguments
	if [ "$DEVELOPER_MODE" = "Y" ]; then
		add_developer_mode_args
	fi

	# If there public address set, add the public address wrapper arguments
	if [ "$ENABLE_LOCALTEST_ADDRESS" = "Y" ]; then
		add_localtest_address_args
	fi

     # Convert wrapper args associative array to index array prior to launch
    local wrapper_args=( )
    for key in "${!wrapper_args_map[@]}"; do
        wrapper_args+=( "${key}=${wrapper_args_map[${key}]}")
    done

	# Convert jvm args associative array to index array prior to launch
	local jvm_args=( )
	for key in "${!jvm_args_map[@]}"; do
		jvm_args+=( "${key}" "${jvm_args_map[${key}]}" )
	done

	# If "--" is already in the args, insert any jvm args before it, else if it isnt there just append the jvm args
	if [[ " ${args[*]} " =~ " -- " ]]; then
		# Insert the jvm args before the "--" in the args array
		args=( "${args[@]/--/${jvm_args[*]} --}" )
	else
		# Append the jvm args to the args array
		args+=( "${jvm_args[@]}" )
	fi
	
    # If "--" is not alraedy in the args, make sure you append it before the wrapper args
	if [[ ! " ${args[*]} " =~ " -- " ]]; then
		args+=( "--" )
	fi

    # Append the wrapper args to the provided args
    args+=("${wrapper_args[@]}")

    # print args for debugging
    echo "******Final args: ${args[@]}"

    entrypoint "${args[@]}"
}

################################################################################
# Create the projects directory and symlink it to the host's projects directory
################################################################################
symlink_projects() {
    # If the project directory symlink isnt already there, create it
    if [ ! -L "${IGNITION_INSTALL_LOCATION}"/data/projects ]; then
        ln -s "${WORKING_DIRECTORY}"/projects "${IGNITION_INSTALL_LOCATION}"/data/
        mkdir -p "${WORKING_DIRECTORY}"/projects
    fi
}

################################################################################
# Copy any modules from the /modules directory into the user lib
################################################################################
copy_modules_to_user_lib() {
    # Copy the modules from the modules folder into the ignition modules folder
	cp -r /modules/* "${IGNITION_INSTALL_LOCATION}"/user-lib/modules/
}

################################################################################
# Enable the developer mode java args so that its easier to upload custom modules
################################################################################
add_developer_mode_args() {
	wrapper_args_map+=( ["-Dia.developer.moduleupload"]="true" )
	wrapper_args_map+=( ["-Dignition.allowunsignedmodules"]="true" )
}

################################################################################
# Add the public address java args so that the gateway can be accessed 
# from the address provided
################################################################################
add_localtest_address_args() {
	jvm_args_map+=( ["-a"]="${TRAEFIK_SERVICE_NAME}.localtest.me" )
	jvm_args_map+=( ["-h"]="${GATEWAY_HTTP_PORT:-8088}" )
	jvm_args_map+=( ["-s"]="${GATEWAY_HTTPS_PORT:-8043}" )
}

################################################################################
# Execute the entrypoint for the container
################################################################################
entrypoint() {

    # Run the entrypoint
    # Check if docker-entrpoint is not in bin directory
    if [ ! -e /usr/local/bin/docker-entrypoint.sh ]; then
        # Run the original entrypoint script
        mv docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
    fi

    echo "Running entrypoint with args $*"
    exec docker-entrypoint.sh "$@"
}


main "${args[*]}"