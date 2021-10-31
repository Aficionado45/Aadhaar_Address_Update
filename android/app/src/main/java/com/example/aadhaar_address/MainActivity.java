package com.example.aadhaar_address;
import android.view.WindowManager;
import android.view.WindowManager.LayoutParams;
import android.os.Bundle; // required for onCreate parameter
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    private static final String INTENT_ACTION =
            "in.gov.uidai.rdservice.face.STATELESS_MATCH";
    private static final String REQUEST =
            "request";
    private static final String RESPONSE =
            "response";
    private static MethodChannel.Result result;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), "going.native.for.userdata").setMethodCallHandler(callHandler);
    }

    private MethodChannel.MethodCallHandler callHandler = new MethodChannel.MethodCallHandler() {

        @Override
        public void onMethodCall(MethodCall methodCall,
                                 MethodChannel.Result result) {
            String ekyc = methodCall.argument("ekyc");
            MainActivity.result = result;
            launchApp2(ekyc);
        }
    };
    @SuppressLint("NewApi")
    private void launchApp2(String ekyc){
        Intent sendIntent = new Intent();
        sendIntent.setAction(INTENT_ACTION);
        Bundle bundle = new Bundle();

        try {
            sendIntent.putExtra(REQUEST,ekyc);
            Log.e("called",ekyc);
            if (sendIntent.resolveActivity(getPackageManager()) != null) {
                startActivityForResult(sendIntent, 123);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onActivityResult(int req, int res, Intent data) {
        if (res == Activity.RESULT_OK && null != data) {
            if (req == 123) {
//                handleMatchResponse(StatelessMatchResponse.fromXML(data.getStringExtra(RESPONSE)))
                result.success(data.getStringExtra(RESPONSE));
            } else if (req == 124) {
                super.onActivityResult(req, res, data);
            }
        }
    }
}
