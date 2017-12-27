package main

import (
	"fmt"
	"net/url"
	"os"
	"os/exec"
	"os/signal"

	"path/filepath"
	"strings"
	"syscall"

	ini "github.com/go-ini/ini"
)

type Settings struct {
	SrvURL      string
	Width       int32
	Height      int32
	Title       string
	URL         string
	AppPid      int
	LauncherPid int
}

var (
	srvPath  = ""
	cefPath  = ""
	cfg, err = ini.LoadSources(ini.LoadOptions{AllowBooleanKeys: true}, "launcher.ini")
	cmdSrv   *exec.Cmd
	cmdApp   *exec.Cmd
	cmdCEF   *exec.Cmd
	wd, _    = os.Getwd()
)

func init() {
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	_srv, _ := cfg.Section("").GetKey("srv")
	_cef, _ := cfg.Section("").GetKey("cef")
	srvPath = _srv.String()
	cefPath = _cef.String()
	srvPath = filepath.Join(wd, filepath.Join(srvPath))
	cefPath = filepath.Join(wd, filepath.Join(cefPath))
}
func main() {
	_title, _ := cfg.Section("").GetKey("app_title")
	_url, _ := cfg.Section("").GetKey("start_url")
	_width, _ := cfg.Section("").GetKey("window_width")
	_height, _ := cfg.Section("").GetKey("window_height")

	srvURL := startSrv()
	//fmt.Print(srvURL)
	startApp()
	w, _ := _width.Int()
	h, _ := _height.Int()
	startCEF(srvURL, _title.String(), _url.String(), w, h)
	startTray()
	Clean()
}
func startTray() {

}
func startCEF(srvURL, title, url0 string, width, height int) {
	args := []string{
		srvURL + "/load?url=" + url.QueryEscape(url0),
		title,
		fmt.Sprintf("%d", width),
		fmt.Sprintf("%d", height),
	}
	cmdCEF = exec.Command(cefPath, args...)
	cmdCEF.Dir = filepath.Dir(cefPath)
	err = cmdCEF.Start()
	if err != nil {
		fmt.Printf("ERR:%s", err)
		killALl()
		os.Exit(1)
	}
	go func() {
		cmdCEF.Wait()
		killALl()
		os.Exit(0)
	}()
}
func startSrv() string {
	buf := make([]byte, 100)
	cmdSrv = exec.Command(srvPath)
	cmdSrv.Dir = filepath.Dir(srvPath)
	outp, _ := cmdSrv.StdoutPipe()
	err := cmdSrv.Start()
	if err != nil {
		fmt.Printf("ERR:%s", err)
		killALl()
		os.Exit(1)
	}
	n, _ := outp.Read(buf)
	return fmt.Sprintf("%s", string(buf[:n]))
}

func startApp() {
	argsString, _ := cfg.Section("").GetKey("start_exec")
	if argsString.String() == "" {
		return
	}
	args := strings.Split(argsString.String(), " ")
	app, _ := filepath.Abs(args[0])
	if len(args) > 1 {
		cmdApp = exec.Command(app, args[1:]...)
	} else {
		cmdApp = exec.Command(app)
	}
	cmdApp.Dir = filepath.Dir(app)
	err := cmdApp.Start()
	if err != nil {
		fmt.Printf("ERR:%s", err)
		killALl()
		os.Exit(1)
	}
}
func Clean() {
	signalChan := make(chan os.Signal, 1)
	cleanupDone := make(chan bool)
	signal.Notify(signalChan,
		os.Interrupt,
		syscall.SIGHUP,
		syscall.SIGINT,
		syscall.SIGTERM,
		syscall.SIGQUIT)
	go func() {
		for _ = range signalChan {
			fmt.Println("\nReceived an interrupt, stopping services...")
			killALl()
			cleanupDone <- true
		}
	}()
	<-cleanupDone
}
func killALl() {
	if cmdApp != nil && cmdApp.Process != nil {
		fmt.Printf("\nclean app process %d", cmdApp.Process.Pid)
		cmdApp.Process.Kill()
	}
	if cmdSrv != nil && cmdSrv.Process != nil {
		fmt.Printf("\nclean srv process %d", cmdSrv.Process.Pid)
		cmdSrv.Process.Kill()
	}
	if cmdCEF != nil && cmdCEF.Process != nil {
		fmt.Printf("\nclean cef process %d", cmdCEF.Process.Pid)
		cmdCEF.Process.Kill()
	}
}
