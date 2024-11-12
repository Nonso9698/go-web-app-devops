# Start with a base Go image for building
FROM golang:1.21 as base

# Set the working directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod ./

# Download all the dependencies
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Build the application for Linux amd64 architecture
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

#######################################################
# Use a distroless image for a minimal runtime environment
FROM gcr.io/distroless/base

# Copy the binary from the build stage
COPY --from=base /app/main .

# Copy the static files from the build stage, if needed
COPY --from=base /app/static ./static

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["./main"]
