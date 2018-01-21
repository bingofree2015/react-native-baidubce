package com.reactnative.baiducloud.videoplayer;

import android.app.Activity;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.reactnative.baiducloud.videoplayer.info.VideoInfo;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        findViewById(R.id.btnopen).setOnClickListener(
                new Button.OnClickListener(){
                    @Override
                    public void onClick(View view) {
                        VideoInfo info = new VideoInfo("Test", "http://iaaje4c72ewjajp0m17.exp.bcevod.com/mda-iabffeayx1c5uv0x/mda-iabffeayx1c5uv0x.m3u8");
                        Intent intent = null;
                        // SimplePlayActivity简易播放窗口，便于快速了解播放流程
                        //intent = new Intent(MainActivity.this, SimplePlayActivity.class);
                        // AdvancedPlayActivity高级播放窗口，内含丰富的播放控制逻辑
                        intent = new Intent(MainActivity.this, AdvancedPlayActivity.class);
                        intent.putExtra("videoInfo", info);
                        startActivity(intent);
                    }
                }
        );
    }
}
