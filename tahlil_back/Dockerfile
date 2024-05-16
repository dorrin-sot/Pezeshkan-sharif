# Use the official Node.js image as the base image
FROM node:18

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the application files into the working directory
COPY package*.json ./

# Install the application dependencies
RUN npm install

COPY . .

# Set Environment Variables
ENV server_port 80
ENV jwt_secret_key H3d1dHUV4cm0PckrePij/NEZ40gQMd5iXP971V4vu9Y=
ENV cookie_max_age 86400000

# Expose the Port
EXPOSE 80

# Define the entry point for the container
CMD ["node", "index.js"]
