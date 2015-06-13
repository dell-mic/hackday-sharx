package controllers;

import models.OrderEntry;
import play.libs.Json;
import play.mvc.*;

public class Application extends Controller {

    public Result index() {
        return ok("hello world");
    }

    public Result recentOrders() {
        return ok(Json.toJson(OrderEntry.recent()));
    }

    public Result allOrders() {
        return ok(Json.toJson(OrderEntry.find.all()));
    }

}
