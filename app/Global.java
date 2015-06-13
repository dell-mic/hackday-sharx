
import com.typesafe.config.Config;
import com.typesafe.config.ConfigFactory;
import models.OrderEntry;
import play.Application;
import play.GlobalSettings;
import play.Logger;
import play.i18n.Messages;
import play.libs.Akka;
import play.libs.F;
import play.mvc.Http;
import play.mvc.Result;
import scala.concurrent.duration.Duration;

import java.util.Random;
import java.util.concurrent.TimeUnit;

import static play.mvc.Results.internalServerError;
import static play.mvc.Results.notFound;

public class Global extends GlobalSettings {

    public void onStart(Application app) {
        Config config = ConfigFactory.load();

//        Logger.info(Akka.system().settings().toString());

        Akka.system().scheduler().schedule(
                Duration.create(1, TimeUnit.SECONDS),
                Duration.create(1000, TimeUnit.MILLISECONDS),     //Frequency 30 minutes
                () -> {
                    OrderEntry orderEntry = new OrderEntry();
                    orderEntry.entityCode = "LH140";
                    orderEntry.price = 70 + randInt(20,200);
                    orderEntry.quantity = 10 + randInt(1,5)*10;
                    orderEntry.seatType = "B";
                    orderEntry.type = "offer";
                    orderEntry.save();
                },
                Akka.system().dispatcher()
        );


    }

    public void onStop(Application app) {
        Logger.info("Global.onStop() callback");
    }

    /**
     * Handle all uncaught exceptions -> Return text only
     *
     * @param request
     * @param t
     * @return
     */
    public F.Promise<Result> onError(Http.RequestHeader request, Throwable t) {
        return F.Promise.<Result> pure(internalServerError(
                Messages.get("error.global", t.getMessage())
        ));
    }


    public F.Promise<Result> onHandlerNotFound(Http.RequestHeader request) {
        return F.Promise.<Result>pure(notFound(
                Messages.get("error.routeNotFound")
        ));
    }

    public static int randInt(int min, int max) {

        // NOTE: Usually this should be a field rather than a method
        // variable so that it is not re-seeded every call.
        Random rand = new Random();

        // nextInt is normally exclusive of the top value,
        // so add 1 to make it inclusive
        int randomNum = rand.nextInt((max - min) + 1) + min;

        return randomNum;
    }





    private void startChallengeTimeoutTask() {
        Logger.info("Starting challenge time out task");

//        //Initialize parameters from config file
//        final int timeoutCheckIntervall = (int) ConfigFactory.load().getDuration("challenge.timeout.check.interval", TimeUnit.MINUTES);
//        final int CHALLENGE_MAX_AGE = (int) ConfigFactory.load().getDuration("challenge.timeout.maxAge", TimeUnit.MINUTES);
//        final int CHALLENGE_WARNING_AGE = (int) ConfigFactory.load().getDuration("challenge.timeout.warningAge", TimeUnit.MINUTES);
//
//        Logger.info("Challenge check interval [minutes]: " + timeoutCheckIntervall);
//        Logger.info("Challenge timeout max age [minutes]: " + CHALLENGE_MAX_AGE);
//        Logger.info("Challenge timeout max age [minutes]: " + CHALLENGE_WARNING_AGE);
//
//
//        ActorRef timeoutsActor = Akka.system().actorOf(Props.create(TimoutsChecker.class), "timeouts-actor");
//
//
//        Akka.system().scheduler().schedule(
//                Duration.create(3, TimeUnit.MINUTES), //Initial delay
//                Duration.create(timeoutCheckIntervall, TimeUnit.MINUTES),     //Frequency
//                timeoutsActor,
//                "checkWarnings",
//                Akka.system().dispatcher(),
//                null
//        );
//
//        Akka.system().scheduler().schedule(
//                Duration.create(7, TimeUnit.MINUTES), //Initial delay
//                Duration.create(timeoutCheckIntervall, TimeUnit.MINUTES),     //Frequency
//                timeoutsActor,
//                "checkTimeouts",
//                Akka.system().dispatcher(),
//                null
//        );



    }

}