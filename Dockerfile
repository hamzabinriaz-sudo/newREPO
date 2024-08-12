# Use the official Node.js image as the base image for building the React app
FROM node:14-alpine AS build

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files from the ClientApp directory
COPY ClientApp/package*.json ./ClientApp/

# Navigate to the ClientApp directory
WORKDIR /app/ClientApp

# Install dependencies
RUN npm install

# Copy the entire application to the container
COPY ClientApp .

# Build the React application
RUN npm run build

# Use a lightweight web server to serve the React application
FROM nginx:alpine

# Copy the build output from the React build stage to the Nginx HTML directory
COPY --from=build /app/ClientApp/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
