# This is a basic VCL configuration file for varnish.  See the vcl(7)
# man page for details on VCL syntax and semantics.


# Backends
{% block backends %}{% endblock %}



#sub vcl_pipe {
#     if (req.http.upgrade) {
#         set bereq.http.upgrade = req.http.upgrade;
#         set req.backend = quijote_cluster;
#     }
#}

acl purge {
    "localhost";
    "10.0.5.0"/24;
}

# no-cache from backend
sub vcl_fetch {
    if (beresp.http.cache-control ~ "no-cache") {
        return(hit_for_pass);
    }
}

sub vcl_recv {
    # no-cache from client
    #if (req.http.cache-control ~ "no-cache") {
    #    return(pass);
    #}

    if (req.request == "PURGE") {
        if (!client.ip ~ purge) {
            error 405 "Not allowed";
       }
       return (lookup);
    } 

    {% block http_hosts %}{% endblock %}

    if (req.url == "^/") {
        set req.backend = default;
    }
}


sub vcl_hit {
    if (req.request == "PURGE") {
        set obj.ttl = 0s;
        error 200 "Purged";
    }
}

sub vcl_miss {
    if (req.request == "PURGE") {
        error 404 "Not in cache";
    }
}

sub vcl_error {
    set obj.http.Content-Type = "text/html; charset=utf-8";
    set obj.http.Retry-After = "5";
    synthetic {"
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
 <html>
  <head>
    <title>"} + obj.status + " " + obj.response + {"</title>
  </head>
  <body>
<!--
    <h1>Error "} + obj.status + " " + obj.response + {"</h1>
    <p>"} + obj.response + {"</p>
-->
    <h3>Backend unavailable:</h3>
    <p>XID: "} + req.xid + {"</p>
    <hr>
    <p>ACMEs RLS Team</p>
  </body>
</html>
"};
    return (deliver);
}
# 
# sub vcl_init {
#       return (ok);
# }
# 
# sub vcl_fini {
#       return (ok);
# }
