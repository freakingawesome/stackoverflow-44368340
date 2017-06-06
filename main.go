package main

import (
	"fmt"
	"net/http"
)

func loginHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("authorization", "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXyLp0aSI6ImefP2GOWEFYWM47ig2W6nrhw")
	fmt.Fprintf(w, "success")
}

func main() {
	http.HandleFunc("/login", loginHandler)
	http.Handle("/", http.FileServer(http.Dir("public")))
	http.ListenAndServe(":9999", nil)
}
