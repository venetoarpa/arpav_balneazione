package it.busnet.omar.arpavbalneazione;

import android.Manifest;
import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.ColorStateList;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.support.annotation.DrawableRes;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.FragmentActivity;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.Toolbar;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.gson.Gson;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;
import com.google.gson.reflect.TypeToken;

import java.util.ArrayList;
import java.util.List;

public class MapsActivity extends AppCompatActivity implements OnMapReadyCallback, GoogleMap.OnMarkerClickListener {

    private GoogleMap mMap;

    private List<Sito> siti;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_maps);
        // Obtain the SupportMapFragment and get notified when the map is ready to be used.


        if (getSupportActionBar() != null){
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setDisplayShowHomeEnabled(true);
        }

        android.support.v7.app.ActionBar bar = getSupportActionBar();
        bar.setBackgroundDrawable(new ColorDrawable(Color.parseColor("#2d7167")));

        Spannable text = new SpannableString(bar.getTitle());
        text.setSpan(new ForegroundColorSpan(Color.WHITE), 0, text.length(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        bar.setTitle(text);

        final Drawable upArrow = getResources().getDrawable(R.drawable.abc_ic_ab_back_material);
        upArrow.setColorFilter(getResources().getColor(android.R.color.white), PorterDuff.Mode.SRC_ATOP);
        getSupportActionBar().setHomeAsUpIndicator(upArrow);

       Gson gson = new Gson();
       String siti_json = getIntent().getStringExtra("siti");
       siti = gson.fromJson(siti_json, new TypeToken<ArrayList<Sito>>(){}.getType());


        List<String> listPermissionsNeeded = new ArrayList<>();
        //if ( ActivityCompat.checkSelfPermission(this.getApplicationContext(), android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
        //    listPermissionsNeeded.add(Manifest.permission.ACCESS_COARSE_LOCATION);
        //}

        if (ActivityCompat.checkSelfPermission(this.getApplicationContext(), Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {

            listPermissionsNeeded.add(Manifest.permission.ACCESS_FINE_LOCATION);
        }

        if (!listPermissionsNeeded.isEmpty()) {
            ActivityCompat.requestPermissions(this, listPermissionsNeeded.toArray(new String[listPermissionsNeeded.size()]),1);
        }else {
            SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                    .findFragmentById(R.id.map);
            mapFragment.getMapAsync(this);
        }

    }


    /**
     * Manipulates the map once available.
     * This callback is triggered when the map is ready to be used.
     * This is where we can add markers or lines, add listeners or move the camera. In this case,
     * we just add a marker near Sydney, Australia.
     * If Google Play services is not installed on the device, the user will be prompted to install
     * it inside the SupportMapFragment. This method will only be triggered once the user has
     * installed Google Play services and returned to the app.
     */
    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;
        //mMap.setOnMarkerClickListener(this);

        // Add a marker in Sydney and move the camera

        //LatLng sydney = new LatLng(-34, 151);
        //mMap.addMarker(new MarkerOptions().position(sydney).title("Marker in Sydney"));

        LatLng primo = null;
        int position = 0;
        for (Sito sito: siti) {
            LatLng pos = new LatLng(Double.parseDouble(sito.y_wgs), Double.parseDouble(sito.x_wgs));
            if(primo == null) primo = pos;

            int resource = R.drawable.red;
            if (sito.statoatt.equals("BLU")) {
               resource = R.drawable.blue;
            } else if (sito.statoatt.equals("GIALLO")) {
                resource = R.drawable.orange;
            }
            Marker m = mMap.addMarker(new MarkerOptions().position(pos).title(sito.descr).icon(BitmapDescriptorFactory.fromBitmap(getMarkerBitmapFromView(resource))));
            m.setTag(position);
            position ++;
        }

        mMap.moveCamera(CameraUpdateFactory.newLatLng(primo));

        if(siti.size() > 1){
            mMap.animateCamera( CameraUpdateFactory.zoomTo( 10.0f ) );
        }else {
            mMap.animateCamera(CameraUpdateFactory.zoomTo(17.0f));
        }

        mMap.setOnInfoWindowClickListener(new GoogleMap.OnInfoWindowClickListener() {
            @Override
            public void onInfoWindowClick(Marker marker) {
                int position = (int) marker.getTag();
                Sito sito = siti.get(position);

                returnToFlutterView(new Gson().toJson(sito));
            }
        });
    }


    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        switch (requestCode) {
            case 1: {

                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {

                    SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                            .findFragmentById(R.id.map);
                    mapFragment.getMapAsync(this);
                    // permission was granted, yay! Do the
                    // contacts-related task you need to do.
                } else {

                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                    Toast.makeText(this, "Concedere tutti i permessi per avere il completo utilizzo dell'applicazione", Toast.LENGTH_SHORT).show();
                }
                return;
            }


            // other 'case' lines to check for other
            // permissions this app might request
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            // Respond to the action bar's Up/Home button
            case android.R.id.home:
                finish();

                return true;
        }
        return super.onOptionsItemSelected(item);
    }


    private void returnToFlutterView(String s) {
        Intent returnIntent = new Intent();
        returnIntent.putExtra("sito", s);
        setResult(Activity.RESULT_OK, returnIntent);
        finish();
    }


    @Override
    public boolean onMarkerClick(Marker marker) {

        int position = (int) marker.getTag();
        Sito sito = siti.get(position);

        returnToFlutterView(new Gson().toJson(sito));

        return false;
    }


    class Sito {
        @Expose
        @SerializedName("codsqst")
        private String codsqst;
        @Expose
        @SerializedName("stato1arp")
        private String stato1arp;
        @Expose
        @SerializedName("statoatt")
        private String statoatt;
        @Expose
        @SerializedName("data_campione")
        private String data_campione;
        @Expose
        @SerializedName("numero_campione")
        private String numero_campione;
        @Expose
        @SerializedName("tipo_analisi")
        private String tipo_analisi;
        @Expose
        @SerializedName("esito_campione")
        private String esito_campione;
        @Expose
        @SerializedName("data_validazione")
        private String data_validazione;
        @Expose
        @SerializedName("descr")
        private String descr;
        @Expose
        @SerializedName("comune")
        private String comune;
        @Expose
        @SerializedName("x_wgs")
        private String x_wgs;
        @Expose
        @SerializedName("y_wgs")
        private String y_wgs;
        @Expose
        @SerializedName("corpo_idrico")
        private String corpo_idrico;

        public String getCodsqst() {
            return codsqst;
        }

        public String getStato1arp() {
            return stato1arp;
        }

        public String getStatoatt() {
            return statoatt;
        }

        public String getData_campione() {
            return data_campione;
        }

        public String getNumero_campione() {
            return numero_campione;
        }

        public String getTipo_analisi() {
            return tipo_analisi;
        }

        public String getEsito_campione() {
            return esito_campione;
        }

        public String getData_validazione() {
            return data_validazione;
        }

        public String getDescr() {
            return descr;
        }

        public String getComune() {
            return comune;
        }

        public String getX_wgs() {
            return x_wgs;
        }

        public String getY_wgs() {
            return y_wgs;
        }

        public String getCorpo_idrico() {
            return corpo_idrico;
        }
    }


    private Bitmap getMarkerBitmapFromView(@DrawableRes int resId) {

        View customMarkerView = ((LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE)).inflate(R.layout.view_custom_marker, null);
        ImageView markerImageView = (ImageView) customMarkerView.findViewById(R.id.profile_image);
        markerImageView.setImageResource(resId);
        customMarkerView.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
        customMarkerView.layout(0, 0, customMarkerView.getMeasuredWidth(), customMarkerView.getMeasuredHeight());
        customMarkerView.buildDrawingCache();
        Bitmap returnedBitmap = Bitmap.createBitmap(customMarkerView.getMeasuredWidth(), customMarkerView.getMeasuredHeight(),
                Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(returnedBitmap);
        canvas.drawColor(Color.WHITE, PorterDuff.Mode.SRC_IN);
        Drawable drawable = customMarkerView.getBackground();
        if (drawable != null)
            drawable.draw(canvas);
        customMarkerView.draw(canvas);
        return returnedBitmap;
    }
}
