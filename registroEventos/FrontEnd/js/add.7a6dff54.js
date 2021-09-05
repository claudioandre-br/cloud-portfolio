(window["webpackJsonp"] = window["webpackJsonp"] || []).push([
    ["add"], {
        "7e55": function(o, r, a) {
            "use strict";
            a.r(r);
            var n = function() {
                    var o = this,
                        r = o.$createElement,
                        a = o._self._c || r;
                    return a("div", {
                        staticClass: "container-fluid mt-4"
                    }, [a("h2", [o._v("Adicionar Evento")]), a("p", [a("small", [a("code", [o._v("POST " + o._s(o.dragonsPostEndpoint))])])]), a("p", [a("small", [a("code", [o._v(o._s(o.dragonsPostBody))])])]), a("p", [a("small", [a("code", [o._v("authorization: " + o._s(o.cognitoIdToken).substring(0, 20) + "[...]")])])]), a("hr"), a("b-form", [a("b-form-group", {
                        attrs: {
                            label: "Nome:",
                            "label-for": "eventoName"
                        }
                    }, [a("b-form-input", {
                        attrs: {
                            id: "eventoName"
                        },
                        model: {
                            value: o.form.eventoName,
                            callback: function(r) {
                                o.$set(o.form, "eventoName", r)
                            },
                            expression: "form.eventoName"
                        }
                    })], 1), a("b-form-group", {
                        attrs: {
                            label: "Descrição:",
                            "label-for": "dragonDescription"
                        }
                    }, [a("b-form-input", {
                        attrs: {
                            id: "dragonDescription"
                        },
                        model: {
                            value: o.form.dragonDescription,
                            callback: function(r) {
                                o.$set(o.form, "dragonDescription", r)
                            },
                            expression: "form.dragonDescription"
                        }
                    })], 1), a("b-form-group", {
                        attrs: {
                            label: "Tipo:",
                            "label-for": "eventoType"
                        }
                    }, [a("b-form-input", {
                        attrs: {
                            id: "eventoType"
                        },
                        model: {
                            value: o.form.eventoType,
                            callback: function(r) {
                                o.$set(o.form, "eventoType", r)
                            },
                            expression: "form.eventoType"
                        }
                    })], 1), a("b-form-group", {
                        attrs: {
                            label: "Local:",
                            "label-for": "eventoLocal"
                        }
                    }, [a("b-form-input", {
                        attrs: {
                            id: "eventoLocal"
                        },
                        model: {
                            value: o.form.eventoLocal,
                            callback: function(r) {
                                o.$set(o.form, "eventoLocal", r)
                            },
                            expression: "form.eventoLocal"
                        }
                    })], 1), a("b-form-group", [a("button", {
                        staticClass: "btn btn-primary",
                        attrs: {
                            type: "button"
                        },
                        on: {
                            click: function(r) {
                                return r.preventDefault(), o.postDragons()
                            }
                        }
                    }, [o._v("POST /events")]), a("b-spinner", {
                        directives: [{
                            name: "show",
                            rawName: "v-show",
                            value: o.loading,
                            expression: "loading"
                        }],
                        attrs: {
                            small: "",
                            label: "Loading.."
                        }
                    })], 1)], 1)], 1)
                },
                t = [],
                e = a("bc3a"),
                i = a.n(e),
                d = {
                    name: "Add",
                    data: function() {
                        return {
                            form: {
                                eventoName: "",
                                dragonDescription: "",
                                eventoType: "",
                                eventoLocal: ""
                            },
                            loading: !1,
                            dragonsEndpoint: localStorage.hasOwnProperty("dragonsEndpoint") ? localStorage.getItem("dragonsEndpoint") : "",
                            cognitoIdToken: localStorage.hasOwnProperty("cognitoIdToken") ? localStorage.getItem("cognitoIdToken") : ""
                        }
                    },
                    computed: {
                        dragonsPostEndpoint: function() {
                            return this.dragonsEndpoint + "events"
                        },
                        dragonsPostBody: function() {
                            return {
                                eventoName: this.form.eventoName,
                                description: this.form.dragonDescription,
                                type: this.form.eventoType,
                                local: this.form.eventoLocal,
                                reportingPhoneNumber: "PHONE_ID",
                                confirmationRequired: !1
                            }
                        }
                    },
                    methods: {
                        postDragons: function() {
                            var o = this;
                            this.loading = !0, i.a.post(this.dragonsPostEndpoint, this.dragonsPostBody, {
                                headers: {
                                    Authorization: this.cognitoIdToken
                                }
                            }).then((function(r) {
                                o.loading = !1, o.form.eventoName = "", o.form.dragonDescription = "", o.form.eventoType = "", o.form.eventoLocal = ""
                            }), (function(r) {
                                alert(r), o.loading = !1
                            }))
                        }
                    }
                },
                s = d,
                g = a("2877"),
                l = Object(g["a"])(s, n, t, !1, null, null, null);
            r["default"] = l.exports
        }
    }
]);