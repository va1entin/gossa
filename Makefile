build:
	cp src/gossa.go gossa.go
	make -C gossa-ui/
	go vet && go fmt
	CGO_ENABLED=0 go build gossa.go
	rm gossa.go

run:
	make build
	./gossa test-fixture

ci:
	timeout 10 make run &
	cp src/gossa_test.go . && sleep 5 && go test
	rm gossa_test.go

watch:
	ls src/* gossa-ui/* | entr -rc make run

ci-watch:
	ls src/* gossa-ui/* | entr -rc make ci

build-all:
	cp src/gossa.go gossa.go
	make -C gossa-ui/
	env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build gossa.go
	mv gossa gossa-linux64
	env GOOS=linux GOARCH=arm go build gossa.go
	mv gossa gossa-linux-arm
	env GOOS=linux GOARCH=arm64 go build gossa.go
	mv gossa gossa-linux-arm64
	env GOOS=darwin GOARCH=amd64 go build gossa.go
	mv gossa gossa-mac
	env GOOS=windows GOARCH=amd64 go build gossa.go
	mv gossa.exe gossa-windows.exe
	rm gossa.go

clean:
	-rm gossa.go
	-rm gossa_test.go
	-rm gossa
	-rm gossa-linux64
	-rm gossa-linux-arm
	-rm gossa-linux-arm64
	-rm gossa-mac
	-rm gossa-windows.exe
