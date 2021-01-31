###
# Base
# Downloads go dependencies and builds the application
###
FROM golang:1.15-alpine as base

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN go build ./cmd/vcadmin

###
# Prod
# Copies the built binary from base and runs it
###
FROM alpine:latest as prod

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copy the Pre-built binary file from the previous stage
COPY --from=base /app/vcadmin .

# Run the executable
CMD ["./vcadmin"]
