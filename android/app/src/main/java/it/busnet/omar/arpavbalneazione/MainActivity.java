package it.busnet.omar.arpavbalneazione;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.flutter.io/battery";
    private static final int MARKERPRESS = 100;
  private MethodChannel.Result result;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {

                  MainActivity.this.result = result;
                  String s = (String)call.argument("siti");
                  openMapActivity(s);
                  Log.d("CHIAMATO","getBatteryLevel" );
                  Log.d("PASSATo",s );
              }
            });
  }


  private void openMapActivity(String siti){
      Intent i = new Intent(MainActivity.this, MapsActivity.class);
      i.putExtra("siti", siti);
      startActivityForResult(i,MARKERPRESS);
  }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == MARKERPRESS) {
            if (resultCode == RESULT_OK) {
                result.success(data.getStringExtra("sito"));
            } else {
                result.error("ACTIVITY_FAILURE", "Failed while launching activity", null);
            }
        }
    }

}





