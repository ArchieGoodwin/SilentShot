package biz.incoding.silentshot;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.hardware.Camera;
import android.hardware.Camera.PictureCallback;
import android.hardware.Camera.PreviewCallback;
import android.net.Uri;
import android.os.Environment;
import android.util.Base64;
import android.view.Gravity;
import android.view.SurfaceView;
import android.widget.FrameLayout;
import android.widget.Toast;

public class SilentShot extends CordovaPlugin {
    private static final int DATA_URL = 1;              // Return base64 encoded string
    private static final int FILE_URI = 0;              // Return file uri (content://media/external/images/media/2 for Android)


    private int mQuality;                   // Compression quality hint (0-100: 0=low quality & high compression, 100=compress of max quality)
    private int targetWidth;                // desired width of the image
    private int targetHeight;               // desired height of the image
    private int cameraDirection;
    private int destType = FILE_URI;
    private static Context _context;
    private static Camera mCamera;
    private static SurfaceView dummy;
    public CallbackContext callbackContext;

	@Override
	public boolean execute(String action, JSONArray args,
			CallbackContext callbackContext) throws JSONException {
        this.callbackContext = callbackContext;
//quality : 50, destinationType : 0, targetWidth: 200, targetHeight: 300, cameraDirection: 2
        if (action.equalsIgnoreCase("makeShot")) {
            releaseCam();
            this.targetHeight = 0;
            this.targetWidth = 0;
            this.mQuality = 80;
            this.cameraDirection = 2;
            JSONObject jsonObject = args.getJSONObject(0); 
            this.mQuality = jsonObject.getInt("quality");
            this.destType = jsonObject.getInt("destinationType");
            this.targetWidth = jsonObject.getInt("targetWidth");
            this.targetHeight = jsonObject.getInt("targetHeight");
            this.cameraDirection = jsonObject.getInt("cameraDirection");
            
            // If the user specifies a 0 or smaller width/height
            // make it -1 so later comparisons succeed
            if (this.targetWidth < 1) {
                this.targetWidth = -1;
            }
            if (this.targetHeight < 1) {
                this.targetHeight = -1;
            }
            
            try {
            	this.takePictureNoPreview(destType);
            }
            catch (IllegalArgumentException e)
            {
                callbackContext.error("Illegal Argument Exception");
                PluginResult r = new PluginResult(PluginResult.Status.ERROR);
                callbackContext.sendPluginResult(r);
                return true;
            }
             
            PluginResult r = new PluginResult(PluginResult.Status.NO_RESULT);
            r.setKeepCallback(true);
            callbackContext.sendPluginResult(r);
            return true;
        }
        return false;
        
	}

    private String getTempDirectoryPath() {
        File cache = null;

        // SD Card Mounted
        if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
            cache = new File(Environment.getExternalStorageDirectory().getAbsolutePath() +
                    "/Android/data/" + cordova.getActivity().getPackageName() + "/cache/");
        }
        // Use internal storage
        else {
            cache = cordova.getActivity().getCacheDir();
        }

        // Create the cache directory if it doesn't exist
        cache.mkdirs();
        return cache.getAbsolutePath();
    }
    
    
    void takePictureNoPreview(final int destType) {
    	
    	final Activity activity = cordova.getActivity();

    	activity.runOnUiThread(new Runnable() {
    	    public void run() {
    	    	dummy = new SurfaceView(activity);
    	        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(2,2,Gravity.BOTTOM);

    	        activity.addContentView(dummy, params);
    	        try {
    	            openFrontFacingCameraGingerbread();
    	        } catch (Exception e) {
    	            e.printStackTrace();
    	            callbackContext.error("Error open camera");
    	            PluginResult r = new PluginResult(PluginResult.Status.ERROR);
    	            callbackContext.sendPluginResult(r);
    	        }
    	    }
    	});
        _context = activity;
    }

    void releaseCam() {
        try {
            if (mCamera != null) {
                mCamera.stopPreview();
                mCamera.setPreviewCallback(null);
                mCamera.setPreviewDisplay(null);
                mCamera.release();
                mCamera = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private PictureCallback getJpegCallback() {
        // if (pictureCallback == null){
        PictureCallback jpeg = new PictureCallback() {
            @Override
            public void onPictureTaken(byte[] data, Camera camera) {
              try {
                  final BitmapFactory.Options bfOptions = new BitmapFactory.Options();
                  bfOptions.inDither = false; // Disable Dithering mode
                  // Tell to gc that whether it needs free memory, the Bitmap can be cleared
                  bfOptions.inPurgeable = true;
                  // Which kind of reference will be used to recover the Bitmap data after being clear,
                  // when it will be used in the future
                  bfOptions.inInputShareable = true;
                  bfOptions.inTempStorage = new byte[32 * 1024];
                  
                  Bitmap bitmap = BitmapFactory.decodeByteArray(data, 0, data.length, bfOptions);
                  int width = bitmap.getWidth();
                  int height = bitmap.getHeight();
                  Matrix rotateRight = new Matrix();
                  rotateRight.preRotate(90);

                  if (android.os.Build.VERSION.SDK_INT > 13) {
                      float[] mirrorY = { -1, 0, 0, 0, 1, 0, 0, 0, 1 };
                      rotateRight = new Matrix();
                      Matrix matrixMirrorY = new Matrix();
                      matrixMirrorY.setValues(mirrorY);

                      rotateRight.postConcat(matrixMirrorY);

                      rotateRight.preRotate(270);

                  }
                  
                  bitmap = Bitmap.createBitmap(bitmap, 0, 0, width, height, rotateRight, true);
					if (targetHeight > 0 && targetWidth > 0) {
						width = bitmap.getWidth();
						height = bitmap.getHeight();
						float scale = 0f;
						if (width > targetWidth || height > targetHeight) {
							scale = Math.min((float) targetWidth / width,
									(float) targetHeight / height);
							Matrix matrix = new Matrix();
							matrix.postScale(scale, scale);
							bitmap = Bitmap.createBitmap(bitmap, 0, 0, width,
									height, matrix, true);
						}

					}                  
                  
                  
                  
                  ByteArrayOutputStream bos = new ByteArrayOutputStream();
                  if (destType == DATA_URL){
	                  try {
	                      if (bitmap.compress(CompressFormat.JPEG, mQuality, bos)) {
	                          byte[] code = bos.toByteArray();
	                          byte[] output = Base64.encode(code, Base64.NO_WRAP);
	                          String js_out = new String(output);
	                          callbackContext.success(js_out);
	                          js_out = null;
	                          output = null;
	                          code = null;
	                      }
	                  } catch (Exception e) {
	                      callbackContext.error("Compress Exception");
	                      PluginResult r = new PluginResult(PluginResult.Status.ERROR);
	                      callbackContext.sendPluginResult(r);
	                      
	                  }
	                  
                  }else if (destType == FILE_URI){
						try {
							if (bitmap.compress(CompressFormat.JPEG, mQuality,
									bos)) {
								File file = new File(getTempDirectoryPath()
										+ File.separator + "temp_emp.jpg");
								if (file.exists())
									file.delete();
								FileOutputStream fos = new FileOutputStream(
										file.getAbsolutePath());
								fos.write(bos.toByteArray());
								callbackContext.success(Uri.fromFile(file).toString());
								fos.close();
								fos = null;
							}
						} catch (Exception e) {
		                    callbackContext.error("IO Exception");
		                    PluginResult r = new PluginResult(PluginResult.Status.ERROR);
		                    callbackContext.sendPluginResult(r);
						}
                  }else{
                      callbackContext.error("Illegal Argument Exception");
                      PluginResult r = new PluginResult(PluginResult.Status.ERROR);
                      callbackContext.sendPluginResult(r);
                  }
                  bos = null;
                  bitmap.recycle();
                  
              } catch (Exception e) {
                  e.printStackTrace();
              }
            	releaseCam();
            }
        };
        return jpeg;
    }

    // Selecting front facing camera.
     void openFrontFacingCameraGingerbread() {
        
        int cameraCount = 0;
        Camera.CameraInfo cameraInfo = new Camera.CameraInfo();
        cameraCount = Camera.getNumberOfCameras();
        for (int camIdx = 0; camIdx < cameraCount; camIdx++) {
            Camera.getCameraInfo(camIdx, cameraInfo);
            if (cameraInfo.facing == Camera.CameraInfo.CAMERA_FACING_FRONT && this.cameraDirection == 2) {
                mCamera = Camera.open(camIdx);
            } else if (cameraInfo.facing == Camera.CameraInfo.CAMERA_FACING_BACK && this.cameraDirection == 1) {
                mCamera = Camera.open(camIdx);
            }
        }
        if (mCamera != null) {
            mCamera.setPreviewCallback(new PreviewCallback() {
                @Override
                public void onPreviewFrame(byte[] data, Camera camera) {
                    //
                }
            });
            try {
                mCamera.setPreviewDisplay(dummy.getHolder());
            } catch (IOException e) {
                e.printStackTrace();
                Toast.makeText(_context, "IOException:" + e.getLocalizedMessage(), Toast.LENGTH_LONG).show();
            }
            mCamera.startPreview();
            mCamera.takePicture(null, null, getJpegCallback());
        }else{
            callbackContext.error("Error open camera");
            PluginResult r = new PluginResult(PluginResult.Status.ERROR);
            callbackContext.sendPluginResult(r);
        }

    }

}
