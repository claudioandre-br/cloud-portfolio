(function(e) {
    function t(t) {
        for (var r, i, u = t[0], l = t[1], d = t[2], c = 0, f = []; c < u.length; c++) i = u[c], Object.prototype.hasOwnProperty.call(a, i) && a[i] && f.push(a[i][0]), a[i] = 0;
        for (r in l) Object.prototype.hasOwnProperty.call(l, r) && (e[r] = l[r]);
        s && s(t);
        while (f.length) f.shift()();
        return o.push.apply(o, d || []), n()
    }

    function n() {
        for (var e, t = 0; t < o.length; t++) {
            for (var n = o[t], r = !0, i = 1; i < n.length; i++) {
                var l = n[i];
                0 !== a[l] && (r = !1)
            }
            r && (o.splice(t--, 1), e = u(u.s = n[0]))
        }
        return e
    }
    var r = {},
        a = {
            app: 0
        },
        o = [];

    function i(e) {
        return u.p + "js/" + ({
            "add~list": "add~list",
            add: "add",
            list: "list",
            config: "config"
        } [e] || e) + "." + {
            "add~list": "d6a797ae",
            add: "7a6dff54",
            list: "51905c9e",
            config: "d237aa2f"
        } [e] + ".js"
    }

    function u(t) {
        if (r[t]) return r[t].exports;
        var n = r[t] = {
            i: t,
            l: !1,
            exports: {}
        };
        return e[t].call(n.exports, n, n.exports, u), n.l = !0, n.exports
    }
    u.e = function(e) {
        var t = [],
            n = a[e];
        if (0 !== n)
            if (n) t.push(n[2]);
            else {
                var r = new Promise((function(t, r) {
                    n = a[e] = [t, r]
                }));
                t.push(n[2] = r);
                var o, l = document.createElement("script");
                l.charset = "utf-8", l.timeout = 120, u.nc && l.setAttribute("nonce", u.nc), l.src = i(e);
                var d = new Error;
                o = function(t) {
                    l.onerror = l.onload = null, clearTimeout(c);
                    var n = a[e];
                    if (0 !== n) {
                        if (n) {
                            var r = t && ("load" === t.type ? "missing" : t.type),
                                o = t && t.target && t.target.src;
                            d.message = "Loading chunk " + e + " failed.\n(" + r + ": " + o + ")", d.name = "ChunkLoadError", d.type = r, d.request = o, n[1](d)
                        }
                        a[e] = void 0
                    }
                };
                var c = setTimeout((function() {
                    o({
                        type: "timeout",
                        target: l
                    })
                }), 12e4);
                l.onerror = l.onload = o, document.head.appendChild(l)
            } return Promise.all(t)
    }, u.m = e, u.c = r, u.d = function(e, t, n) {
        u.o(e, t) || Object.defineProperty(e, t, {
            enumerable: !0,
            get: n
        })
    }, u.r = function(e) {
        "undefined" !== typeof Symbol && Symbol.toStringTag && Object.defineProperty(e, Symbol.toStringTag, {
            value: "Module"
        }), Object.defineProperty(e, "__esModule", {
            value: !0
        })
    }, u.t = function(e, t) {
        if (1 & t && (e = u(e)), 8 & t) return e;
        if (4 & t && "object" === typeof e && e && e.__esModule) return e;
        var n = Object.create(null);
        if (u.r(n), Object.defineProperty(n, "default", {
                enumerable: !0,
                value: e
            }), 2 & t && "string" != typeof e)
            for (var r in e) u.d(n, r, function(t) {
                return e[t]
            }.bind(null, r));
        return n
    }, u.n = function(e) {
        var t = e && e.__esModule ? function() {
            return e["default"]
        } : function() {
            return e
        };
        return u.d(t, "a", t), t
    }, u.o = function(e, t) {
        return Object.prototype.hasOwnProperty.call(e, t)
    }, u.p = "/vigilante/", u.oe = function(e) {
        throw console.error(e), e
    };
    var l = window["webpackJsonp"] = window["webpackJsonp"] || [],
        d = l.push.bind(l);
    l.push = t, l = l.slice();
    for (var c = 0; c < l.length; c++) t(l[c]);
    var s = d;
    o.push([0, "chunk-vendors"]), n()
})({
    0: function(e, t, n) {
        e.exports = n("56d7")
    },
    "56d7": function(e, t, n) {
        "use strict";
        n.r(t);
        n("e260"), n("e6cf"), n("cca6"), n("a79d"), n("fb6a"), n("4de4"), n("e792"), n("0cdd");
        var r = n("2b0e"),
            a = n("5f5b");
        n("ab8b"), n("2dd8");
        r["default"].use(a["a"]);
        var o = function() {
                var e = this,
                    t = e.$createElement,
                    n = e._self._c || t;
                return n("div", {
                    attrs: {
                        id: "app"
                    }
                }, [n("b-navbar", {
                    attrs: {
                        toggleable: "md",
                        type: "dark",
                        variant: "dark"
                    }
                }, [n("b-navbar-toggle", {
                    attrs: {
                        target: "nav_collapse"
                    }
                }), n("b-navbar-brand", {
                    attrs: {
                        to: "/"
                    }
                }, [e._v("📖 Eventos")]), n("b-collapse", {
                    attrs: {
                        "is-nav": "",
                        id: "nav_collapse"
                    }
                }, [n("b-navbar-nav", [n("b-nav-item", {
                    attrs: {
                        to: "/"
                    }
                }, [e._v("Home")]), n("b-nav-item", {
                    attrs: {
                        to: "/list"
                    }
                }, [e._v("Listar")]), n("b-nav-item", {
                    attrs: {
                        to: "/add"
                    }
                }, [e._v("Adicionar")])], 1)], 1)], 1), n("router-view")], 1)
            },
            i = [],
            u = n("2877"),
            l = {},
            d = Object(u["a"])(l, o, i, !1, null, null, null),
            c = d.exports,
            s = (n("d3b7"), n("3ca3"), n("ddb0"), n("8c4f"));
        r["default"].use(s["a"]);
        var f = [{
                path: "/",
                alias: "/id_token*",
                name: "Config",
                component: function() {
                    return n.e("config").then(n.bind(null, "1071"))
                }
            }, {
                path: "/list",
                name: "Listar",
                component: function() {
                    return Promise.all([n.e("add~list"), n.e("list")]).then(n.bind(null, "1a33"))
                }
            }, {
                path: "/add",
                name: "Adicionar",
                component: function() {
                    return Promise.all([n.e("add~list"), n.e("add")]).then(n.bind(null, "7e55"))
                }
            }],
            p = new s["a"]({
                routes: f
            }),
            v = p;
        r["default"].config.productionTip = !1;
        var b = function(e, t, n) {
            n = n || "...";
            var r = document.createElement("div");
            r.innerHTML = e;
            var a = r.textContent;
            return a.length > t ? a.slice(0, t) + n : a
        };
        r["default"].filter("truncate", b), new r["default"]({
            router: v,
            render: function(e) {
                return e(c)
            }
        }).$mount("#app")
    }
});