# Define a base image and TAG the phase using the "as" keyword
FROM node:alpine as builder

# CD into the correct directory in the container for executing commands late
WORKDIR "/app"

# Copy over the package.json file from the current directory on the Docker Server to the current directory "." in the container
# package.json informs NPM of the necessary dependencies that will be installed later
COPY package.json .

# Kick off an NPM Install based on the package.json parameters
RUN npm install

# Copy over all the source code from the current directory of the docker server to the current directory in the container
#   The current directory of the container has been declared earlier with the WORKDIR instruction
COPY ./ ./

# Define the default command to be executed by the container when the container starts
RUN npm run build

# Running "npm run build" should create a directory named "build" within /app (/app/build) with the compiled binary
#   This behavior is defined by the script executed by "npm run build"

# Declaring a second FROM statement implies a second phase
# Begin our RUN PHASE
FROM nginx

# Copy over contents from a container in the previous phase to the new container we're building here
# COPY --from=[phaseTag] [previousPhaseContainerTargetPath] [currentContainerDestinationPath]
COPY --from=builder /app/build /usr/share/nginx/html