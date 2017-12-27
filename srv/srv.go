package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
	"os"
	"strings"
	"time"
)

func main() {
	listen := flag.String("b", "127.0.0.1", "binding ip")
	flag.Parse()
	fmt.Fprintf(os.Stdout, "http://%s:%s", *listen, run_http_server(*listen))
	select {}
}

func handler(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	if strings.HasPrefix(req.URL.Path, "/load") {
		f, _ := os.OpenFile("start.html", os.O_RDONLY, 0666)
		c, _ := ioutil.ReadAll(f)
		fmt.Fprintf(w, string(c))
	} else if strings.HasPrefix(req.URL.Path, "/ping") {
		_url := req.URL.Query().Get("url")
		err := HTTPGet(_url, 5000)
		if err == nil {
			fmt.Fprintf(w, "1")
		}
		fmt.Println(err)
	}
}

func run_http_server(ip string) (port string) {
	http.HandleFunc("/", handler)
	listener, err := net.Listen("tcp", ip+":0")
	if err != nil {
		panic(err)
	}
	go func() {
		panic(http.Serve(listener, nil))
	}()
	return fmt.Sprintf("%d", listener.Addr().(*net.TCPAddr).Port)
}

func HTTPGet(URL string, timeout int) (err error) {
	tr := &http.Transport{}
	var resp *http.Response
	var client *http.Client
	defer func() {
		if resp != nil && resp.Body != nil {
			resp.Body.Close()
		}
		tr.CloseIdleConnections()
	}()
	client = &http.Client{Timeout: time.Millisecond * time.Duration(timeout), Transport: tr}
	resp, err = client.Get(URL)
	if err != nil {
		return
	}
	return
}
