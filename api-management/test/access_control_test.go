package hub_test

import (
	"flag"
	"net/http"
	"os"
	"testing"

	"github.com/gavv/httpexpect/v2"
)

var url = flag.String("url", "", "url to request")

func hubTester(t *testing.T) *httpexpect.Expect {
	if url == nil || *url == "" {
		t.Fatal("required API_GATEWAY_URL env variable is missing, got:" + *url)
	}
	return httpexpect.Default(t, *url)
}

// TestAccessControlSimple test simple Access Control.
func TestAccessControlSimple_AdminUser(t *testing.T) {
	e := hubTester(t)
	admin_token := os.Getenv("ADMIN_USER_TOKEN")
	if admin_token == "" {
		t.Fatal("required ADMIN_USER_TOKEN env variable is missing")
	}
	admin_user := e.Builder(func(req *httpexpect.Request) { req.WithHeader("Authorization", "Bearer "+admin_token) })

	admin_user.GET("/admin/").
		Expect().
		Status(http.StatusOK)

	admin_user.GET("/weather/licensed/forecast/").
		Expect().
		Status(http.StatusForbidden)
}

func TestAccessControlSimple_LicensedUser(t *testing.T) {
	e := hubTester(t)
	licensed_token := os.Getenv("LICENSED_USER_TOKEN")
	if licensed_token == "" {
		t.Fatal("required LICENSED_USER_TOKEN env variable is missing")
	}
	licensed_user := e.Builder(func(req *httpexpect.Request) { req.WithHeader("Authorization", "Bearer "+licensed_token) })

	// check licensed user access
	licensed_user.GET("/admin/").
		Expect().
		Status(http.StatusForbidden)

	licensed_user.GET("/weather/licensed/forecast/").
		Expect().
		Status(http.StatusOK)
}

func TestAccessControlAdvanced_AdminUser(t *testing.T) {
	e := hubTester(t)
	admin_token := os.Getenv("ADMIN_USER_TOKEN")
	if admin_token == "" {
		t.Fatal("required ADMIN_USER_TOKEN env variable is missing")
	}
	admin_user := e.Builder(func(req *httpexpect.Request) { req.WithHeader("Authorization", "Bearer "+admin_token) })

	// Check admin access
	admin_user.GET("/admin/").
		Expect().
		Status(http.StatusOK)

	admin_user.GET("/weather/licensed/forecast/").
		Expect().
		Status(http.StatusOK)

	admin_user.PATCH("/weather/licensed/forecast/").
		Expect().
		Status(http.StatusOK)
	admin_user.DELETE("/weather/licensed/forecast/").
		Expect().
		Status(http.StatusForbidden)
}

func TestAccessControlAdvanced_LicensedUser(t *testing.T) {
	e := hubTester(t)
	licensed_token := os.Getenv("LICENSED_USER_TOKEN")
	if licensed_token == "" {
		t.Fatal("required LICENSED_USER_TOKEN env variable is missing")
	}
	licensed_user := e.Builder(func(req *httpexpect.Request) { req.WithHeader("Authorization", "Bearer "+licensed_token) })

	// check licensed user access
	licensed_user.GET("/admin/").
		Expect().
		Status(http.StatusForbidden)
	licensed_user.GET("/weather/licensed/forecast/").
		Expect().
		Status(http.StatusOK)
	licensed_user.PATCH("/weather/licensed/forecast/").
		Expect().
		Status(http.StatusForbidden)
}
