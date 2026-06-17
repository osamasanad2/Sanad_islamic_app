package com.katma1.Quran1;

import com.example.sanad_app.R;
import android.animation.*;
import com.example.sanad_app.R;
import android.app.*;
import com.example.sanad_app.R;
import android.content.*;
import com.example.sanad_app.R;
import android.content.res.*;
import com.example.sanad_app.R;
import android.graphics.*;
import com.example.sanad_app.R;
import android.graphics.drawable.*;
import com.example.sanad_app.R;
import android.media.*;
import com.example.sanad_app.R;
import android.net.*;
import com.example.sanad_app.R;
import android.os.*;
import com.example.sanad_app.R;
import android.text.*;
import com.example.sanad_app.R;
import android.text.style.*;
import com.example.sanad_app.R;
import android.util.*;
import com.example.sanad_app.R;
import android.view.*;
import com.example.sanad_app.R;
import android.view.View.*;
import com.example.sanad_app.R;
import android.view.animation.*;
import com.example.sanad_app.R;
import android.webkit.*;
import com.example.sanad_app.R;
import android.widget.*;
import com.example.sanad_app.R;
import androidx.annotation.*;
import com.example.sanad_app.R;
import androidx.appcompat.app.AppCompatActivity;
import com.example.sanad_app.R;
import androidx.fragment.app.DialogFragment;
import com.example.sanad_app.R;
import androidx.fragment.app.Fragment;
import com.example.sanad_app.R;
import androidx.fragment.app.FragmentManager;
import java.io.*;
import java.text.*;
import java.util.*;
import java.util.regex.*;
import org.json.*;

public class StatsActivity extends AppCompatActivity {
	
	@Override
	protected void onCreate(Bundle _savedInstanceState) {
		super.onCreate(_savedInstanceState);
		setContentView(R.layout.stats);
		initialize(_savedInstanceState);
		initializeLogic();
	}
	
	private void initialize(Bundle _savedInstanceState) {
	}
	
	private void initializeLogic() {
		// ========================================================
		// 1. الإعدادات والملفات والمتغيرات الأساسية
		// ========================================================
		final android.content.SharedPreferences prefs = getSharedPreferences("QuranPrefs", android.content.Context.MODE_PRIVATE);
		final android.content.SharedPreferences memoData = getSharedPreferences("memo_data", android.content.Context.MODE_PRIVATE);
		final android.content.SharedPreferences planData = getSharedPreferences("memo_plan", android.content.Context.MODE_PRIVATE);
		final android.content.SharedPreferences historyData = getSharedPreferences("memo_history", android.content.Context.MODE_PRIVATE);
		final boolean isDarkMode = prefs.getBoolean("dark_mode", false);
		final android.graphics.Typeface quranFont = android.graphics.Typeface.createFromAsset(getAssets(), "fonts/add.ttf");
		final float dp = getResources().getDisplayMetrics().density;
		
		android.widget.ScrollView scroll = new android.widget.ScrollView(this);
		scroll.setBackgroundColor(isDarkMode ? android.graphics.Color.parseColor("#121212") : android.graphics.Color.parseColor("#FDF9F1")); 
		scroll.setLayoutParams(new android.view.ViewGroup.LayoutParams(-1, -1));
		
		final android.widget.RelativeLayout rootFrame = new android.widget.RelativeLayout(this);
		final android.widget.LinearLayout mainLayout = new android.widget.LinearLayout(this);
		mainLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
		mainLayout.setPadding(30, 40, 30, 80);
		scroll.addView(mainLayout);
		rootFrame.addView(scroll);
		setContentView(rootFrame);
		
		final android.widget.LinearLayout plansContainer = new android.widget.LinearLayout(this);
		plansContainer.setOrientation(android.widget.LinearLayout.VERTICAL);
		
		// ========================================================
		// 2. نظام الاحتفال البصري (Confetti)
		// ========================================================
		abstract class ConfettiHelper { abstract void shoot(); }
		final ConfettiHelper confettiHelper = new ConfettiHelper() {
			    @Override void shoot() {
				        final int[] colors = {0xFF4CAF50, 0xFF2196F3, 0xFFFFC107, 0xFFE91E63, 0xFF9C27B0};
				        java.util.Random rnd = new java.util.Random();
				        int width = getResources().getDisplayMetrics().widthPixels;
				        for (int i = 0; i < 40; i++) {
					            final android.view.View particle = new android.view.View(StatsActivity.this);
					            android.graphics.drawable.GradientDrawable dot = new android.graphics.drawable.GradientDrawable();
					            dot.setShape(rnd.nextBoolean() ? android.graphics.drawable.GradientDrawable.OVAL : android.graphics.drawable.GradientDrawable.RECTANGLE);
					            dot.setColor(colors[rnd.nextInt(colors.length)]); particle.setBackground(dot);
					            int size = (int) ((8 + rnd.nextInt(10)) * dp);
					            android.widget.RelativeLayout.LayoutParams p = new android.widget.RelativeLayout.LayoutParams(size, size);
					            p.addRule(android.widget.RelativeLayout.CENTER_HORIZONTAL); p.topMargin = (int) (100 * dp); particle.setLayoutParams(p);
					            rootFrame.addView(particle);
					            float targetX = (rnd.nextFloat() * width) - (width / 2f); float targetY = (300 + rnd.nextInt(500)) * dp;
					            particle.animate().translationX(targetX).translationY(targetY).rotation(rnd.nextInt(360)).alpha(0f)
					                    .setDuration(1000 + rnd.nextInt(1000)).setInterpolator(new android.view.animation.DecelerateInterpolator())
					                    .withEndAction(new Runnable() { @Override public void run() { rootFrame.removeView(particle); } }).start();
					        }
				    }
		};
		
		// ========================================================
		// 3. بناء الواجهة والمعالجة 
		// ========================================================
		abstract class UIBuilder { abstract void buildAll(); abstract void refreshPlans(); }
		final UIBuilder uiBuilder = new UIBuilder() {
			    final java.util.ArrayList<String> allSurahNames = new java.util.ArrayList<>();
			    final java.util.ArrayList<Integer> allSurahAyahs = new java.util.ArrayList<>();
			    
			    final java.util.ArrayList<String> completedSurahNames = new java.util.ArrayList<>();
			    final java.util.ArrayList<Integer> completedSurahNumbers = new java.util.ArrayList<>();
			    
			    int totalQuranAyahs = 6236, totalMemorizedAyahs = 0, fullyMemorizedSurahs = 0;
			    
			    final String[] themeMemoPri = {"#2E7D32", "#0277BD", "#6A1B9A", "#C62828", "#E65100", "#37474F"}; 
			    final String[] themeMemoBg = {"#E8F5E9", "#E1F5FE", "#F3E5F5", "#FFEBEE", "#FFF3E0", "#ECEFF1"}; 
			    final String reviewPriColor = "#D84315";
			    final String reviewBgColor = "#FBE9E7";
			
			    @Override void buildAll() {
				        new Thread(new Runnable() {
					            @Override public void run() {
						                totalMemorizedAyahs = 0; fullyMemorizedSurahs = 0;
						                allSurahNames.clear(); allSurahAyahs.clear();
						                completedSurahNames.clear(); completedSurahNumbers.clear();
						                
						                try {
							                    java.io.InputStream isIndex = getAssets().open("index.json");
							                    java.util.Scanner scIndex = new java.util.Scanner(isIndex).useDelimiter("\\A");
							                    org.json.JSONArray indexArray = new org.json.JSONArray(scIndex.hasNext() ? scIndex.next() : "");
							                    scIndex.close();
							                    for (int i = 0; i < indexArray.length(); i++) {
								                        org.json.JSONObject surahObj = indexArray.getJSONObject(i);
								                        int totalVerses = 0;
								                        try { totalVerses = surahObj.getInt("total_verses"); } catch(Exception e) { totalVerses = Integer.parseInt(surahObj.getString("total_verses")); }
								                        String sName = surahObj.has("name") ? surahObj.getString("name") : "سورة " + (i+1);
								                        allSurahNames.add(sName); allSurahAyahs.add(totalVerses);
								                        
								                        int savedVerses = 0; try { savedVerses = Integer.parseInt(memoData.getString("surah_" + (i + 1) + "_saved", "0")); } catch(Exception e){}
								                        if (savedVerses > 0) { 
									                            totalMemorizedAyahs += savedVerses; 
									                            if (savedVerses >= totalVerses && totalVerses > 0) {
										                                fullyMemorizedSurahs++; completedSurahNames.add(sName); completedSurahNumbers.add(i + 1);
										                            }
									                        }
								                    }
							                } catch (Exception e) {}
						                runOnUiThread(new Runnable() { @Override public void run() { drawUI(); } });
						            }
					        }).start();
				    }
			
			    void drawUI() {
				        mainLayout.removeAllViews();
				        
				        // --- 1. الشريط العلوي ---
				        android.widget.RelativeLayout topBar = new android.widget.RelativeLayout(StatsActivity.this); topBar.setPadding(0, 0, 0, 30);
				        
				        android.widget.TextView btnBack = new android.widget.TextView(StatsActivity.this); btnBack.setText("❮"); btnBack.setTextSize(24); btnBack.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); btnBack.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.BLACK); btnBack.setPadding(20, 10, 20, 10);
				        android.widget.RelativeLayout.LayoutParams backParams = new android.widget.RelativeLayout.LayoutParams(-2, -2); backParams.addRule(android.widget.RelativeLayout.ALIGN_PARENT_LEFT); backParams.addRule(android.widget.RelativeLayout.CENTER_VERTICAL); btnBack.setLayoutParams(backParams);
				        btnBack.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { finish(); } });
				        
				        android.widget.TextView tvTitle = new android.widget.TextView(StatsActivity.this); tvTitle.setText("لوحة القيادة 👑"); tvTitle.setTextSize(22); tvTitle.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.parseColor("#2E7D32")); tvTitle.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
				        android.widget.RelativeLayout.LayoutParams titleParams = new android.widget.RelativeLayout.LayoutParams(-2, -2); titleParams.addRule(android.widget.RelativeLayout.CENTER_IN_PARENT); tvTitle.setLayoutParams(titleParams);
				        
				        android.widget.TextView btnResetAll = new android.widget.TextView(StatsActivity.this); btnResetAll.setText("🗑️"); btnResetAll.setTextSize(20); btnResetAll.setPadding(20, 10, 20, 10);
				        android.widget.RelativeLayout.LayoutParams resetParams = new android.widget.RelativeLayout.LayoutParams(-2, -2); resetParams.addRule(android.widget.RelativeLayout.ALIGN_PARENT_RIGHT); resetParams.addRule(android.widget.RelativeLayout.CENTER_VERTICAL); btnResetAll.setLayoutParams(resetParams);
				        btnResetAll.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                final android.app.Dialog d = new android.app.Dialog(StatsActivity.this); d.requestWindowFeature(android.view.Window.FEATURE_NO_TITLE);
						                android.widget.LinearLayout l = new android.widget.LinearLayout(StatsActivity.this); l.setOrientation(android.widget.LinearLayout.VERTICAL); l.setPadding(60, 60, 60, 60);
						                android.graphics.drawable.GradientDrawable bg = new android.graphics.drawable.GradientDrawable(); bg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE); bg.setCornerRadius(60f); l.setBackground(bg);
						                android.widget.TextView tvT = new android.widget.TextView(StatsActivity.this); tvT.setText("تصفير الإحصائيات ⚠️"); tvT.setTextSize(20); tvT.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); tvT.setTextColor(android.graphics.Color.parseColor("#F44336")); tvT.setPadding(0,0,0,20);
						                android.widget.TextView tvM = new android.widget.TextView(StatsActivity.this); tvM.setText("هل أنت متأكد من مسح جميع بيانات الحفظ والإنجازات الخاصة بك؟"); tvM.setTextSize(16); tvM.setTextColor(android.graphics.Color.GRAY); tvM.setPadding(0,0,0,40);
						                android.widget.LinearLayout btns = new android.widget.LinearLayout(StatsActivity.this); btns.setOrientation(android.widget.LinearLayout.HORIZONTAL);
						                android.widget.Button btnC = new android.widget.Button(StatsActivity.this); btnC.setText("إلغاء"); btnC.setBackgroundColor(android.graphics.Color.TRANSPARENT); btnC.setTextColor(android.graphics.Color.GRAY); android.widget.LinearLayout.LayoutParams p1 = new android.widget.LinearLayout.LayoutParams(0, -2, 1f); btnC.setLayoutParams(p1);
						                android.widget.Button btnO = new android.widget.Button(StatsActivity.this); btnO.setText("مسح نهائي"); btnO.setTextColor(android.graphics.Color.WHITE); android.graphics.drawable.GradientDrawable obg = new android.graphics.drawable.GradientDrawable(); obg.setColor(android.graphics.Color.parseColor("#F44336")); obg.setCornerRadius(40f); btnO.setBackground(obg); android.widget.LinearLayout.LayoutParams p2 = new android.widget.LinearLayout.LayoutParams(0, -2, 1f); btnO.setLayoutParams(p2);
						                btns.addView(btnC); btns.addView(btnO); l.addView(tvT); l.addView(tvM); l.addView(btns);
						                btnC.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { d.dismiss(); } });
						                btnO.setOnClickListener(new android.view.View.OnClickListener() { 
							                    @Override public void onClick(android.view.View v) { 
								                        memoData.edit().clear().apply(); planData.edit().clear().apply(); historyData.edit().clear().apply(); prefs.edit().putInt("global_streak_count", 0).apply();
								                        d.dismiss(); 
								                        android.widget.Toast.makeText(StatsActivity.this, "تم تصفير البيانات بنجاح 🧹", android.widget.Toast.LENGTH_SHORT).show();
								                        recreate(); // نقوم بإعادة بناء كاملة لضمان التصفير الفعلي
								                    } 
							                });
						                d.setContentView(l); d.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.TRANSPARENT)); d.show();
						            }
					        });
				        
				        topBar.addView(btnBack); topBar.addView(tvTitle); topBar.addView(btnResetAll); mainLayout.addView(topBar);
				
				        // --- 2. نظام المستويات ---
				        String levelName = "مبتدئ الطيبيين"; String levelIcon = "🌱";
				        if(totalMemorizedAyahs > 6000) { levelName = "حامل القرآن"; levelIcon = "👑"; }
				        else if(totalMemorizedAyahs > 3000) { levelName = "رفيق الدرب"; levelIcon = "💎"; }
				        else if(totalMemorizedAyahs > 1000) { levelName = "حافظ مجتهد"; levelIcon = "🔥"; }
				        else if(totalMemorizedAyahs > 100) { levelName = "طالب علم"; levelIcon = "📖"; }
				        else if(totalMemorizedAyahs > 0) { levelName = "محب للقرآن"; levelIcon = "⭐"; }
				
				        android.widget.LinearLayout levelCard = new android.widget.LinearLayout(StatsActivity.this); levelCard.setOrientation(android.widget.LinearLayout.VERTICAL); levelCard.setPadding(40, 50, 40, 50); levelCard.setElevation(15f);
				        android.graphics.drawable.GradientDrawable cardBg = new android.graphics.drawable.GradientDrawable(); cardBg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE); cardBg.setCornerRadius(40f); levelCard.setBackground(cardBg);
				        
				        android.widget.TextView tvLvl = new android.widget.TextView(StatsActivity.this); tvLvl.setText(levelIcon + " المستوى: " + levelName); tvLvl.setTextSize(20); tvLvl.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); tvLvl.setTextColor(android.graphics.Color.parseColor("#2E7D32")); tvLvl.setGravity(android.view.Gravity.CENTER);
				        float overallPercent = Math.min(((float) totalMemorizedAyahs / totalQuranAyahs) * 100, 100f);
				        android.widget.TextView tvPercentVal = new android.widget.TextView(StatsActivity.this); tvPercentVal.setText(String.format(java.util.Locale.US, "%.1f%% من المصحف", overallPercent)); tvPercentVal.setTextSize(14); tvPercentVal.setTextColor(android.graphics.Color.GRAY); tvPercentVal.setGravity(android.view.Gravity.CENTER); tvPercentVal.setPadding(0, 10, 0, 20);
				        
				        android.widget.ProgressBar mainProgressBar = new android.widget.ProgressBar(StatsActivity.this, null, android.R.attr.progressBarStyleHorizontal); mainProgressBar.setMax(10000); mainProgressBar.setProgress((int)(overallPercent * 100)); mainProgressBar.setScaleY(2f); mainProgressBar.getProgressDrawable().setColorFilter(android.graphics.Color.parseColor("#4CAF50"), android.graphics.PorterDuff.Mode.SRC_IN);
				        levelCard.addView(tvLvl); levelCard.addView(tvPercentVal); levelCard.addView(mainProgressBar); mainLayout.addView(levelCard);
				
				        // --- 3. الإحصائيات السريعة ---
				        android.widget.LinearLayout gridLayout = new android.widget.LinearLayout(StatsActivity.this); gridLayout.setOrientation(android.widget.LinearLayout.HORIZONTAL); gridLayout.setWeightSum(3); gridLayout.setPadding(0, 30, 0, 30);
				        abstract class MiniCard { abstract android.widget.LinearLayout build(String val, String tit, String col, final Runnable onClickAction); }
				        MiniCard mc = new MiniCard() {
					            @Override android.widget.LinearLayout build(String val, String tit, String col, final Runnable onClickAction) {
						                android.widget.LinearLayout c = new android.widget.LinearLayout(StatsActivity.this); c.setOrientation(android.widget.LinearLayout.VERTICAL); c.setPadding(10, 20, 10, 20); c.setElevation(10f);
						                android.graphics.drawable.GradientDrawable bg = new android.graphics.drawable.GradientDrawable(); bg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE); bg.setCornerRadius(25f); c.setBackground(bg);
						                android.widget.LinearLayout.LayoutParams p = new android.widget.LinearLayout.LayoutParams(0, -2, 1f); p.setMargins(10, 10, 10, 10); c.setLayoutParams(p);
						                android.widget.TextView v = new android.widget.TextView(StatsActivity.this); v.setText(val); v.setTextSize(18); v.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); v.setTextColor(android.graphics.Color.parseColor(col)); v.setGravity(android.view.Gravity.CENTER);
						                android.widget.TextView t = new android.widget.TextView(StatsActivity.this); t.setText(tit); t.setTextSize(10); t.setTextColor(android.graphics.Color.GRAY); t.setGravity(android.view.Gravity.CENTER); t.setPadding(0, 5, 0, 0);
						                c.addView(v); c.addView(t); 
						                if(onClickAction != null) { c.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View view) { onClickAction.run(); } }); }
						                return c;
						            }
					        };
				
				        Runnable onSurahsClick = new Runnable() {
					            @Override public void run() {
						                if(completedSurahNames.isEmpty()) {
							                    android.widget.Toast.makeText(StatsActivity.this, "لم تكتمل أي سورة بعد.", android.widget.Toast.LENGTH_SHORT).show();
							                    return;
							                }
						                final android.app.Dialog d = new android.app.Dialog(StatsActivity.this); d.requestWindowFeature(android.view.Window.FEATURE_NO_TITLE);
						                android.widget.LinearLayout l = new android.widget.LinearLayout(StatsActivity.this); l.setOrientation(android.widget.LinearLayout.VERTICAL); l.setPadding(40, 60, 40, 40);
						                android.graphics.drawable.GradientDrawable bg = new android.graphics.drawable.GradientDrawable(); bg.setColor(isDarkMode ? android.graphics.Color.parseColor("#1E1E1E") : android.graphics.Color.parseColor("#F5F9F6")); bg.setCornerRadius(50f); l.setBackground(bg);
						                
						                android.widget.TextView tvT = new android.widget.TextView(StatsActivity.this); tvT.setText("تفاصيل: السور المكتملة"); tvT.setTextSize(20); tvT.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); tvT.setTextColor(android.graphics.Color.parseColor("#00695C")); tvT.setGravity(android.view.Gravity.CENTER); tvT.setPadding(0,0,0,40); l.addView(tvT);
						                
						                android.widget.ScrollView sv = new android.widget.ScrollView(StatsActivity.this); android.widget.LinearLayout listLayout = new android.widget.LinearLayout(StatsActivity.this); listLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
						                
						                for(int i=0; i<completedSurahNames.size(); i++) {
							                    android.widget.LinearLayout item = new android.widget.LinearLayout(StatsActivity.this); item.setOrientation(android.widget.LinearLayout.HORIZONTAL); item.setGravity(android.view.Gravity.CENTER_VERTICAL); item.setPadding(30,30,30,30);
							                    android.widget.LinearLayout.LayoutParams itemP = new android.widget.LinearLayout.LayoutParams(-1, -2); itemP.setMargins(0,0,0,20); item.setLayoutParams(itemP);
							                    android.graphics.drawable.GradientDrawable itemBg = new android.graphics.drawable.GradientDrawable(); itemBg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE); itemBg.setCornerRadius(30f); item.setBackground(itemBg); item.setElevation(5f);
							                    
							                    android.view.View dot = new android.view.View(StatsActivity.this); android.widget.LinearLayout.LayoutParams dotP = new android.widget.LinearLayout.LayoutParams((int)(15*dp), (int)(15*dp)); dotP.setMargins(0,0,20,0); dot.setLayoutParams(dotP);
							                    android.graphics.drawable.GradientDrawable dotBg = new android.graphics.drawable.GradientDrawable(); dotBg.setShape(android.graphics.drawable.GradientDrawable.OVAL); dotBg.setColor(android.graphics.Color.parseColor("#4CAF50")); dot.setBackground(dotBg);
							                    
							                    android.widget.LinearLayout txtLayout = new android.widget.LinearLayout(StatsActivity.this); txtLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
							                    android.widget.TextView tName = new android.widget.TextView(StatsActivity.this); tName.setText(completedSurahNames.get(i)); tName.setTextSize(16); tName.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.BLACK);
							                    android.widget.TextView tNum = new android.widget.TextView(StatsActivity.this); tNum.setText("ترتيبها: " + completedSurahNumbers.get(i)); tNum.setTextSize(12); tNum.setTextColor(android.graphics.Color.GRAY);
							                    txtLayout.addView(tName); txtLayout.addView(tNum);
							                    
							                    item.addView(dot); item.addView(txtLayout); listLayout.addView(item);
							                }
						                sv.addView(listLayout); android.widget.LinearLayout.LayoutParams svParams = new android.widget.LinearLayout.LayoutParams(-1, (int)(400*dp)); sv.setLayoutParams(svParams); l.addView(sv);
						                
						                android.widget.TextView btnClose = new android.widget.TextView(StatsActivity.this); btnClose.setText("إغلاق"); btnClose.setTextSize(16); btnClose.setTextColor(android.graphics.Color.parseColor("#00695C")); btnClose.setGravity(android.view.Gravity.CENTER); btnClose.setPadding(0,30,0,0);
						                btnClose.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { d.dismiss(); } }); l.addView(btnClose);
						                
						                d.setContentView(l); d.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.TRANSPARENT)); d.show();
						            }
					        };
				
				        gridLayout.addView(mc.build(fullyMemorizedSurahs+"", "سور كاملة", "#E64A19", onSurahsClick));
				        gridLayout.addView(mc.build(totalMemorizedAyahs+"", "آية محفوظة", "#1976D2", null));
				        gridLayout.addView(mc.build(prefs.getInt("global_streak_count", 0)+"", "يوم متتالي", "#FBC02D", null));
				        mainLayout.addView(gridLayout);
				
				        // ========================================================
				        // 📊 4. الرسم البياني (الأعمدة) لآخر 7 أيام (أعدناه هنا)
				        // ========================================================
				        android.widget.LinearLayout chartCard = new android.widget.LinearLayout(StatsActivity.this);
				        chartCard.setOrientation(android.widget.LinearLayout.VERTICAL); chartCard.setPadding(30, 40, 30, 40); chartCard.setElevation(15f); chartCard.setBackground(cardBg);
				        android.widget.LinearLayout.LayoutParams chartParams = new android.widget.LinearLayout.LayoutParams(-1, -2); chartParams.setMargins(0, 10, 0, 30); chartCard.setLayoutParams(chartParams);
				
				        android.widget.TextView tvChartTitle = new android.widget.TextView(StatsActivity.this);
				        tvChartTitle.setText("النشاط السريع (آخر 7 أيام) 📊"); tvChartTitle.setTextSize(16); tvChartTitle.setTextColor(android.graphics.Color.GRAY); tvChartTitle.setPadding(0, 0, 0, 40);
				
				        android.widget.LinearLayout barsLayout = new android.widget.LinearLayout(StatsActivity.this);
				        barsLayout.setOrientation(android.widget.LinearLayout.HORIZONTAL); barsLayout.setWeightSum(7); barsLayout.setGravity(android.view.Gravity.BOTTOM); barsLayout.setLayoutParams(new android.widget.LinearLayout.LayoutParams(-1, (int)(120*dp))); 
				        barsLayout.setLayoutDirection(android.view.View.LAYOUT_DIRECTION_LTR); 
				
				        final String[] arabicDaysNames = {"الأحد", "الاثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"};
				        java.util.Calendar weekCal = java.util.Calendar.getInstance();
				        int currentDow = weekCal.get(java.util.Calendar.DAY_OF_WEEK) - 1; 
				        weekCal.add(java.util.Calendar.DAY_OF_YEAR, -currentDow);
				
				        int[] weekData = new int[7];
				        for(int i=0; i<7; i++) {
					            weekData[i] = historyData.getInt("global_read_day_" + weekCal.get(java.util.Calendar.DAY_OF_YEAR), 0);
					            weekCal.add(java.util.Calendar.DAY_OF_YEAR, 1);
					        }
				
				        for(int i = 6; i >= 0; i--) {
					            final int dayVal = weekData[i]; 
					            boolean isToday = (i == currentDow);
					            
					            android.widget.LinearLayout barContainer = new android.widget.LinearLayout(StatsActivity.this);
					            barContainer.setOrientation(android.widget.LinearLayout.VERTICAL); barContainer.setGravity(android.view.Gravity.BOTTOM | android.view.Gravity.CENTER_HORIZONTAL); barContainer.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, -1, 1f));
					            
					            android.widget.TextView tvVal = new android.widget.TextView(StatsActivity.this);
					            tvVal.setText(dayVal > 0 ? String.valueOf(dayVal) : ""); tvVal.setTextSize(10); tvVal.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); tvVal.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.DKGRAY); tvVal.setGravity(android.view.Gravity.CENTER);
					            
					            final android.view.View bar = new android.view.View(StatsActivity.this);
					            android.graphics.drawable.GradientDrawable barColor = new android.graphics.drawable.GradientDrawable();
					            // وضعنا لون رمادي للأعمدة لكي لا تختفي تماماً عند التصفير
					            barColor.setColor(isToday ? android.graphics.Color.parseColor("#4A7C59") : (isDarkMode ? android.graphics.Color.parseColor("#424242") : android.graphics.Color.parseColor("#E0E0E0")));
					            barColor.setCornerRadii(new float[]{15f,15f,15f,15f,0f,0f,0f,0f}); bar.setBackground(barColor);
					            
					            final int targetHeight = dayVal == 0 ? (int)(5*dp) : Math.min((dayVal * 2) + (int)(10*dp), (int)(90*dp));
					            android.widget.LinearLayout.LayoutParams bp = new android.widget.LinearLayout.LayoutParams((int)(20*dp), 0); bp.setMargins(0, 10, 0, 10); bar.setLayoutParams(bp);
					            
					            android.widget.TextView tvDay = new android.widget.TextView(StatsActivity.this);
					            tvDay.setText(arabicDaysNames[i]); tvDay.setTextSize(10); tvDay.setTextColor(isToday ? android.graphics.Color.parseColor("#4A7C59") : android.graphics.Color.GRAY); tvDay.setGravity(android.view.Gravity.CENTER);
					            
					            barContainer.addView(tvVal); barContainer.addView(bar); barContainer.addView(tvDay); barsLayout.addView(barContainer);
					
					            bar.post(new Runnable() {
						                @Override public void run() {
							                    android.animation.ValueAnimator anim = android.animation.ValueAnimator.ofInt(0, targetHeight); anim.setDuration(800);
							                    anim.addUpdateListener(new android.animation.ValueAnimator.AnimatorUpdateListener() {
								                        @Override public void onAnimationUpdate(android.animation.ValueAnimator a) {
									                            android.widget.LinearLayout.LayoutParams p = (android.widget.LinearLayout.LayoutParams) bar.getLayoutParams();
									                            p.height = (int) a.getAnimatedValue(); bar.setLayoutParams(p);
									                        }
								                    });
							                    anim.start();
							                }
						            });
					        }
				        chartCard.addView(tvChartTitle); chartCard.addView(barsLayout); mainLayout.addView(chartCard);
				
				        // ========================================================
				        // 🗓️ 5. تقويم الشهر الحالي 
				        // ========================================================
				        android.widget.LinearLayout calCard = new android.widget.LinearLayout(StatsActivity.this);
				        calCard.setOrientation(android.widget.LinearLayout.VERTICAL); calCard.setPadding(30, 40, 30, 40); calCard.setElevation(15f); calCard.setBackground(cardBg);
				        android.widget.LinearLayout.LayoutParams cp = new android.widget.LinearLayout.LayoutParams(-1, -2); cp.setMargins(0, 0, 0, 30); calCard.setLayoutParams(cp);
				        
				        java.util.Calendar monthCal = java.util.Calendar.getInstance(); int currentMonth = monthCal.get(java.util.Calendar.MONTH);
				        String[] arabicMonths = {"يناير","فبراير","مارس","أبريل","مايو","يونيو","يوليو","أغسطس","سبتمبر","أكتوبر","نوفمبر","ديسمبر"};
				        
				        android.widget.TextView calTitle = new android.widget.TextView(StatsActivity.this);
				        calTitle.setText("نشاط شهر " + arabicMonths[currentMonth] + " 📅"); calTitle.setTextSize(16); calTitle.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); calTitle.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.DKGRAY); calTitle.setPadding(0, 0, 0, 20); calCard.addView(calTitle);
				        
				        android.widget.LinearLayout daysHeader = new android.widget.LinearLayout(StatsActivity.this);
				        daysHeader.setOrientation(android.widget.LinearLayout.HORIZONTAL); daysHeader.setWeightSum(7); daysHeader.setPadding(0,0,0,10);
				        String[] shortDays = {"الأحد", "الأثنبن", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"};
				        for(String sd : shortDays) {
					            android.widget.TextView td = new android.widget.TextView(StatsActivity.this); td.setText(sd); td.setTextSize(12); td.setTextColor(android.graphics.Color.GRAY); td.setGravity(android.view.Gravity.CENTER);
					            td.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, -2, 1f)); daysHeader.addView(td);
					        }
				        calCard.addView(daysHeader);
				
				        monthCal.set(java.util.Calendar.DAY_OF_MONTH, 1);
				        int firstDayOfWeek = monthCal.get(java.util.Calendar.DAY_OF_WEEK); 
				        int daysInMonth = monthCal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
				        
				        android.widget.LinearLayout monthGrid = new android.widget.LinearLayout(StatsActivity.this);
				        monthGrid.setOrientation(android.widget.LinearLayout.VERTICAL);
				        
				        int dayCounter = 1; boolean started = false;
				        java.util.Calendar todayCal = java.util.Calendar.getInstance();
				        int todayDate = todayCal.get(java.util.Calendar.DAY_OF_MONTH);
				        int currentYear = todayCal.get(java.util.Calendar.YEAR);
				        
				        for (int r = 0; r < 6; r++) { 
					            android.widget.LinearLayout row = new android.widget.LinearLayout(StatsActivity.this);
					            row.setOrientation(android.widget.LinearLayout.HORIZONTAL); row.setWeightSum(7);
					            
					            for (int c = 1; c <= 7; c++) {
						                if (r == 0 && c == firstDayOfWeek) started = true;
						                
						                android.widget.LinearLayout boxContainer = new android.widget.LinearLayout(StatsActivity.this);
						                boxContainer.setGravity(android.view.Gravity.CENTER); boxContainer.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, -2, 1f));
						                
						                if (started && dayCounter <= daysInMonth) {
							                    final int d = dayCounter;
							                    java.util.Calendar dataCal = java.util.Calendar.getInstance(); dataCal.set(currentYear, currentMonth, dayCounter);
							                    final int dOfYear = dataCal.get(java.util.Calendar.DAY_OF_YEAR);
							                    final int readAyahs = historyData.getInt("global_read_day_" + dOfYear, 0);
							                    
							                    android.widget.TextView box = new android.widget.TextView(StatsActivity.this);
							                    android.widget.LinearLayout.LayoutParams boxP = new android.widget.LinearLayout.LayoutParams((int)(35*dp), (int)(35*dp));
							                    boxP.setMargins(0, (int)(4*dp), 0, (int)(4*dp)); box.setLayoutParams(boxP);
							                    box.setText(String.valueOf(dayCounter)); box.setTextSize(14); box.setGravity(android.view.Gravity.CENTER);
							                    
							                    android.graphics.drawable.GradientDrawable boxBg = new android.graphics.drawable.GradientDrawable();
							                    boxBg.setCornerRadius(15f); 
							                    
							                    if(readAyahs == 0) {
								                        boxBg.setColor(isDarkMode ? android.graphics.Color.parseColor("#333333") : android.graphics.Color.parseColor("#F5F5F5")); 
								                        box.setTextColor(android.graphics.Color.GRAY);
								                        if(dayCounter == todayDate) { boxBg.setStroke((int)(2*dp), android.graphics.Color.parseColor("#4CAF50")); }
								                    }
							                    else if(readAyahs < 20) { boxBg.setColor(android.graphics.Color.parseColor("#C8E6C9")); box.setTextColor(android.graphics.Color.parseColor("#1B5E20")); }
							                    else if(readAyahs < 50) { boxBg.setColor(android.graphics.Color.parseColor("#81C784")); box.setTextColor(android.graphics.Color.parseColor("#1B5E20")); }
							                    else { boxBg.setColor(android.graphics.Color.parseColor("#2E7D32")); box.setTextColor(android.graphics.Color.WHITE); }
							                    
							                    box.setBackground(boxBg);
							                    box.setOnClickListener(new android.view.View.OnClickListener() {
								                        @Override public void onClick(android.view.View v) {
									                            android.widget.Toast.makeText(StatsActivity.this, "يوم " + d + ": قرأت " + readAyahs + " آية", android.widget.Toast.LENGTH_SHORT).show();
									                        }
								                    });
							                    boxContainer.addView(box); dayCounter++;
							                } else {
							                    android.view.View empty = new android.view.View(StatsActivity.this); empty.setLayoutParams(new android.widget.LinearLayout.LayoutParams((int)(35*dp), (int)(35*dp)));
							                    boxContainer.addView(empty);
							                }
						                row.addView(boxContainer);
						            }
					            monthGrid.addView(row);
					            if (dayCounter > daysInMonth) break;
					        }
				        calCard.addView(monthGrid); mainLayout.addView(calCard);
				
				        // --- 6. محدد الألوان ---
				        android.widget.HorizontalScrollView colorScroll = new android.widget.HorizontalScrollView(StatsActivity.this); colorScroll.setHorizontalScrollBarEnabled(false);
				        final android.widget.LinearLayout themeLayout = new android.widget.LinearLayout(StatsActivity.this); themeLayout.setOrientation(android.widget.LinearLayout.HORIZONTAL); themeLayout.setPadding(10, 10, 10, 30); themeLayout.setGravity(android.view.Gravity.CENTER);
				        abstract class ColorDrawer { abstract void drawColors(); }
				        final ColorDrawer colorDrawer = new ColorDrawer() {
					            @Override void drawColors() {
						                themeLayout.removeAllViews();
						                int currentThemeIdx = prefs.getInt("plan_theme_idx", 0);
						                for(int c=0; c<themeMemoPri.length; c++) {
							                    final int idx = c;
							                    android.view.View colorBox = new android.view.View(StatsActivity.this);
							                    android.graphics.drawable.GradientDrawable cBg = new android.graphics.drawable.GradientDrawable(); 
							                    cBg.setShape(android.graphics.drawable.GradientDrawable.RECTANGLE); cBg.setCornerRadius(20f); 
							                    cBg.setColor(android.graphics.Color.parseColor(themeMemoPri[c]));
							                    if(currentThemeIdx == idx) cBg.setStroke((int)(4*dp), android.graphics.Color.parseColor("#FFCA28")); else cBg.setStroke((int)(1*dp), android.graphics.Color.TRANSPARENT);
							                    colorBox.setBackground(cBg); colorBox.setElevation(8f);
							                    android.widget.LinearLayout.LayoutParams cp = new android.widget.LinearLayout.LayoutParams((int)(45*dp), (int)(45*dp)); cp.setMargins(20,10,20,10); colorBox.setLayoutParams(cp);
							                    colorBox.setOnClickListener(new android.view.View.OnClickListener() {
								                        @Override public void onClick(android.view.View v) { prefs.edit().putInt("plan_theme_idx", idx).apply(); drawColors(); refreshPlans(); }
								                    });
							                    themeLayout.addView(colorBox);
							                }
						            }
					        };
				        colorDrawer.drawColors(); colorScroll.addView(themeLayout); mainLayout.addView(colorScroll);
				
				        // --- 7. أزرار إضافة الخطط ---
				        android.widget.LinearLayout addBtnsLayout = new android.widget.LinearLayout(StatsActivity.this); addBtnsLayout.setOrientation(android.widget.LinearLayout.HORIZONTAL); addBtnsLayout.setPadding(0, 0, 0, 30);
				        android.widget.Button btnAddMemo = new android.widget.Button(StatsActivity.this); btnAddMemo.setText("إضافة حفظ ➕"); btnAddMemo.setTextColor(android.graphics.Color.parseColor("#424242")); android.graphics.drawable.GradientDrawable btnMbg = new android.graphics.drawable.GradientDrawable(); btnMbg.setColor(android.graphics.Color.parseColor("#EEEEEE")); btnMbg.setCornerRadius(30f); btnAddMemo.setBackground(btnMbg); android.widget.LinearLayout.LayoutParams pAddM = new android.widget.LinearLayout.LayoutParams(0, -2, 1f); pAddM.setMargins(10,0,10,0); btnAddMemo.setLayoutParams(pAddM);
				        android.widget.Button btnAddReview = new android.widget.Button(StatsActivity.this); btnAddReview.setText("إضافة مراجعة ➕"); btnAddReview.setTextColor(android.graphics.Color.parseColor("#424242")); android.graphics.drawable.GradientDrawable btnRbg = new android.graphics.drawable.GradientDrawable(); btnRbg.setColor(android.graphics.Color.parseColor("#EEEEEE")); btnRbg.setCornerRadius(30f); btnAddReview.setBackground(btnRbg); android.widget.LinearLayout.LayoutParams pAddR = new android.widget.LinearLayout.LayoutParams(0, -2, 1f); pAddR.setMargins(10,0,10,0); btnAddReview.setLayoutParams(pAddR);
				        addBtnsLayout.addView(btnAddMemo); addBtnsLayout.addView(btnAddReview); mainLayout.addView(addBtnsLayout);
				
				        abstract class DialogHelper { abstract void showPlanDialog(final String planType); }
				        final DialogHelper dh = new DialogHelper() {
					            @Override void showPlanDialog(final String planType) {
						                final android.app.Dialog dialog = new android.app.Dialog(StatsActivity.this); dialog.requestWindowFeature(android.view.Window.FEATURE_NO_TITLE);
						                android.widget.LinearLayout dL = new android.widget.LinearLayout(StatsActivity.this); dL.setOrientation(android.widget.LinearLayout.VERTICAL); dL.setPadding(60,60,60,60);
						                android.graphics.drawable.GradientDrawable dBg = new android.graphics.drawable.GradientDrawable(); dBg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE); dBg.setCornerRadius(50f); dL.setBackground(dBg);
						                android.widget.TextView title = new android.widget.TextView(StatsActivity.this); title.setText("خطة " + planType + " ✨"); title.setTextSize(20); title.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); title.setTextColor(android.graphics.Color.parseColor("#4CAF50")); title.setPadding(0,0,0,30); dL.addView(title);
						                final android.widget.Spinner sp = new android.widget.Spinner(StatsActivity.this); android.widget.ArrayAdapter<String> adp = new android.widget.ArrayAdapter<>(StatsActivity.this, android.R.layout.simple_spinner_item, allSurahNames); adp.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item); sp.setAdapter(adp); dL.addView(sp);
						                android.widget.TextView t2 = new android.widget.TextView(StatsActivity.this); t2.setText("المدة بالأيام:"); t2.setPadding(0,30,0,10); dL.addView(t2);
						                final android.widget.EditText edtDays = new android.widget.EditText(StatsActivity.this); edtDays.setInputType(android.text.InputType.TYPE_CLASS_NUMBER); edtDays.setHint("مثال: 10"); dL.addView(edtDays);
						                android.widget.Button btnSave = new android.widget.Button(StatsActivity.this); btnSave.setText("بدء"); btnSave.setTextColor(android.graphics.Color.WHITE); android.graphics.drawable.GradientDrawable sBg = new android.graphics.drawable.GradientDrawable(); sBg.setColor(android.graphics.Color.parseColor("#4CAF50")); sBg.setCornerRadius(30f); btnSave.setBackground(sBg); android.widget.LinearLayout.LayoutParams bp = new android.widget.LinearLayout.LayoutParams(-1,-2); bp.setMargins(0,40,0,0); btnSave.setLayoutParams(bp); dL.addView(btnSave);
						                btnSave.setOnClickListener(new android.view.View.OnClickListener() {
							                    @Override public void onClick(android.view.View v) {
								                        int selSurah = sp.getSelectedItemPosition(); int count = planData.getInt("plans_count", 0);
								                        for(int i=1; i<=count; i++) { if(planData.getBoolean("plan_"+i+"_active", false) && planData.getInt("plan_"+i+"_surah", -1) == selSurah && planData.getString("plan_"+i+"_type", "حفظ").equals(planType)) { android.widget.Toast.makeText(getApplicationContext(), "السورة موجودة مسبقاً في هذه القائمة!", android.widget.Toast.LENGTH_SHORT).show(); return; } }
								                        String dStr = edtDays.getText().toString();
								                        if(!dStr.isEmpty() && Integer.parseInt(dStr) > 0) {
									                            int newId = count + 1; planData.edit().putInt("plans_count", newId).putBoolean("plan_" + newId + "_active", true).putString("plan_" + newId + "_type", planType).putInt("plan_" + newId + "_surah", selSurah).putInt("plan_" + newId + "_days", Integer.parseInt(dStr)).putInt("plan_" + newId + "_sessions", 0).apply();
									                            dialog.dismiss(); refreshPlans(); 
									                        }
								                    }
							                });
						                dialog.setContentView(dL); dialog.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.TRANSPARENT)); dialog.show();
						            }
					        };
				        btnAddMemo.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { dh.showPlanDialog("حفظ"); } });
				        btnAddReview.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { dh.showPlanDialog("مراجعة"); } });
				
				        if(plansContainer.getParent() != null) { ((android.view.ViewGroup)plansContainer.getParent()).removeView(plansContainer); }
				        mainLayout.addView(plansContainer);
				        refreshPlans();
				    }
			
			    // --- 8. دالة بناء وتحديث الخطط ---
			    @Override void refreshPlans() {
				        plansContainer.removeAllViews();
				        int currentThemeIdx = prefs.getInt("plan_theme_idx", 0);
				        int plansCount = planData.getInt("plans_count", 0);
				        
				        abstract class ActionDialog { abstract void show(String title, String msg, String confirmText, String colorHex, final Runnable onConfirm); }
				        final ActionDialog actionDialog = new ActionDialog() {
					            @Override void show(String title, String msg, String confirmText, String colorHex, final Runnable onConfirm) {
						                final android.app.Dialog d = new android.app.Dialog(StatsActivity.this); d.requestWindowFeature(android.view.Window.FEATURE_NO_TITLE);
						                android.widget.LinearLayout l = new android.widget.LinearLayout(StatsActivity.this); l.setOrientation(android.widget.LinearLayout.VERTICAL); l.setPadding((int)(30*dp), (int)(30*dp), (int)(30*dp), (int)(30*dp)); android.graphics.drawable.GradientDrawable bg = new android.graphics.drawable.GradientDrawable(); bg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE); bg.setCornerRadius(60f); l.setBackground(bg);
						                android.widget.TextView tvT = new android.widget.TextView(StatsActivity.this); tvT.setText(title); tvT.setTextSize(22); tvT.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); tvT.setTextColor(android.graphics.Color.parseColor(colorHex)); tvT.setPadding(0,0,0,(int)(10*dp));
						                android.widget.TextView tvM = new android.widget.TextView(StatsActivity.this); tvM.setText(msg); tvM.setTextSize(16); tvM.setTextColor(android.graphics.Color.GRAY); tvM.setPadding(0,0,0,(int)(30*dp));
						                android.widget.LinearLayout btns = new android.widget.LinearLayout(StatsActivity.this); btns.setOrientation(android.widget.LinearLayout.HORIZONTAL);
						                android.widget.Button btnC = new android.widget.Button(StatsActivity.this); btnC.setText("إلغاء"); btnC.setBackgroundColor(android.graphics.Color.TRANSPARENT); btnC.setTextColor(android.graphics.Color.GRAY); android.widget.LinearLayout.LayoutParams p1 = new android.widget.LinearLayout.LayoutParams(0, -2, 1f); btnC.setLayoutParams(p1);
						                android.widget.Button btnO = new android.widget.Button(StatsActivity.this); btnO.setText(confirmText); btnO.setTextColor(android.graphics.Color.WHITE); android.graphics.drawable.GradientDrawable obg = new android.graphics.drawable.GradientDrawable(); obg.setColor(android.graphics.Color.parseColor(colorHex)); obg.setCornerRadius(40f); btnO.setBackground(obg); android.widget.LinearLayout.LayoutParams p2 = new android.widget.LinearLayout.LayoutParams(0, -2, 1f); btnO.setLayoutParams(p2);
						                btns.addView(btnC); btns.addView(btnO); l.addView(tvT); l.addView(tvM); l.addView(btns);
						                btnC.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { d.dismiss(); } });
						                btnO.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { onConfirm.run(); d.dismiss(); } });
						                d.setContentView(l); d.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.TRANSPARENT)); d.show();
						            }
					        };
				
				        for (int i = 1; i <= plansCount; i++) {
					            final int planId = i;
					            if (!planData.getBoolean("plan_" + planId + "_active", false)) continue;
					            
					            final String pType = planData.getString("plan_" + planId + "_type", "حفظ");
					            final int sIdx = planData.getInt("plan_" + planId + "_surah", 0);
					            final int days = planData.getInt("plan_" + planId + "_days", 30);
					            final int completedSessions = planData.getInt("plan_" + planId + "_sessions", 0);
					            final int renderDay = completedSessions + 1;
					            
					            String priColor = pType.equals("حفظ") ? themeMemoPri[currentThemeIdx] : reviewPriColor;
					            String bgColor = pType.equals("حفظ") ? themeMemoBg[currentThemeIdx] : reviewBgColor;
					
					            int totalA = allSurahAyahs.get(sIdx);
					            int savedVerses = 0; try { savedVerses = Integer.parseInt(memoData.getString("surah_" + (sIdx + 1) + "_saved", "0")); } catch(Exception e){}
					            
					            int ayahsPerDay = (int) Math.ceil((double) totalA / days);
					            final int startAyah = ((renderDay - 1) * ayahsPerDay) + 1;
					            final int endAyah = Math.min(renderDay * ayahsPerDay, totalA);
					            final int todayTotalAyahs = (endAyah >= startAyah) ? (endAyah - startAyah) + 1 : 0;
					
					            android.widget.LinearLayout pCard = new android.widget.LinearLayout(StatsActivity.this);
					            pCard.setOrientation(android.widget.LinearLayout.VERTICAL); pCard.setPadding(40, 40, 40, 40); pCard.setElevation(20f); 
					            android.graphics.drawable.GradientDrawable pBg = new android.graphics.drawable.GradientDrawable(); pBg.setColor(android.graphics.Color.parseColor(isDarkMode ? "#2C2C2C" : bgColor)); pBg.setCornerRadius(40f); 
					            if(isDarkMode && pType.equals("مراجعة")) pBg.setStroke(3, android.graphics.Color.parseColor(reviewPriColor));
					            pCard.setBackground(pBg);
					            android.widget.LinearLayout.LayoutParams prms = new android.widget.LinearLayout.LayoutParams(-1, -2); prms.setMargins(0, 0, 0, 40); pCard.setLayoutParams(prms);
					            
					            android.widget.LinearLayout planHeader = new android.widget.LinearLayout(StatsActivity.this); planHeader.setOrientation(android.widget.LinearLayout.HORIZONTAL); planHeader.setGravity(android.view.Gravity.CENTER_VERTICAL);
					            android.widget.LinearLayout hTexts = new android.widget.LinearLayout(StatsActivity.this); hTexts.setOrientation(android.widget.LinearLayout.VERTICAL); android.widget.LinearLayout.LayoutParams hParams = new android.widget.LinearLayout.LayoutParams(0, -2, 1f); hParams.setMargins(10, 0, 10, 0); hTexts.setLayoutParams(hParams);
					            
					            android.widget.TextView tT = new android.widget.TextView(StatsActivity.this); tT.setText(pType + ": " + allSurahNames.get(sIdx)); tT.setTextSize(18); tT.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); tT.setTextColor(android.graphics.Color.parseColor(priColor)); 
					            android.widget.TextView tSaved = new android.widget.TextView(StatsActivity.this); tSaved.setText(pType.equals("حفظ") ? "تم حفظ: " + savedVerses + " / " + totalA : "سورة كاملة للمراجعة"); tSaved.setTextSize(12); tSaved.setTextColor(android.graphics.Color.parseColor("#757575")); 
					            hTexts.addView(tT); hTexts.addView(tSaved); planHeader.addView(hTexts); pCard.addView(planHeader);
					
					            android.widget.TextView tTargetDesc = new android.widget.TextView(StatsActivity.this);
					            if (renderDay > days) { tTargetDesc.setText("🎉 الخطة مكتملة بنجاح."); } 
					            else { tTargetDesc.setText("الورد " + renderDay + ": من الآية " + startAyah + " إلى " + endAyah + " (" + todayTotalAyahs + " آيات)"); }
					            tTargetDesc.setTextSize(15); tTargetDesc.setTextColor(isDarkMode ? android.graphics.Color.DKGRAY : android.graphics.Color.parseColor("#424242")); tTargetDesc.setPadding(0, 20, 0, 30); pCard.addView(tTargetDesc);
					            
					            android.widget.ProgressBar planPb = new android.widget.ProgressBar(StatsActivity.this, null, android.R.attr.progressBarStyleHorizontal);
					            planPb.setMax(days); planPb.setProgress(completedSessions); planPb.setScaleY(1.5f); planPb.getProgressDrawable().setColorFilter(android.graphics.Color.parseColor(priColor), android.graphics.PorterDuff.Mode.SRC_IN);
					            android.widget.LinearLayout.LayoutParams pbParams = new android.widget.LinearLayout.LayoutParams(-1, -2); pbParams.setMargins(0, 0, 0, 30); planPb.setLayoutParams(pbParams); pCard.addView(planPb);
					
					            android.widget.LinearLayout btnsRow = new android.widget.LinearLayout(StatsActivity.this); btnsRow.setOrientation(android.widget.LinearLayout.HORIZONTAL); btnsRow.setGravity(android.view.Gravity.CENTER_VERTICAL);
					            android.widget.ImageView btnDel = new android.widget.ImageView(StatsActivity.this); btnDel.setImageResource(android.R.drawable.ic_menu_delete); btnDel.setColorFilter(android.graphics.Color.parseColor("#F44336")); btnDel.setPadding(15,15,15,15); android.widget.LinearLayout.LayoutParams icP = new android.widget.LinearLayout.LayoutParams((int)(40*dp),(int)(40*dp)); icP.setMargins(0,0,15,0); btnDel.setLayoutParams(icP);
					            android.widget.ImageView btnReset = new android.widget.ImageView(StatsActivity.this); btnReset.setImageResource(android.R.drawable.ic_popup_sync); btnReset.setColorFilter(android.graphics.Color.parseColor("#FF9800")); btnReset.setPadding(15,15,15,15); btnReset.setLayoutParams(icP);
					            
					            android.widget.Button btnGo = new android.widget.Button(StatsActivity.this); btnGo.setText("اقرأ 📖"); btnGo.setTextColor(android.graphics.Color.parseColor(priColor));
					            android.graphics.drawable.GradientDrawable goBg = new android.graphics.drawable.GradientDrawable(); goBg.setColor(android.graphics.Color.TRANSPARENT); goBg.setStroke(3, android.graphics.Color.parseColor(priColor)); goBg.setCornerRadius(25f); 
					            btnGo.setBackground(goBg); android.widget.LinearLayout.LayoutParams goP = new android.widget.LinearLayout.LayoutParams(0, -2, 1f); goP.setMargins(0,0,15,0); btnGo.setLayoutParams(goP);
					            
					            android.widget.Button btnDone = new android.widget.Button(StatsActivity.this); btnDone.setText("إتمام ✅"); btnDone.setTextColor(android.graphics.Color.WHITE);
					            android.graphics.drawable.GradientDrawable doneBg = new android.graphics.drawable.GradientDrawable(); doneBg.setColor(android.graphics.Color.parseColor(priColor)); doneBg.setCornerRadius(25f); android.widget.LinearLayout.LayoutParams doneP = new android.widget.LinearLayout.LayoutParams(0, -2, 1f); btnDone.setLayoutParams(doneP);
					            
					            btnsRow.addView(btnDel); btnsRow.addView(btnReset); btnsRow.addView(btnGo); btnsRow.addView(btnDone); pCard.addView(btnsRow); plansContainer.addView(pCard);
					            
					            if(renderDay <= days) {
						                btnGo.setOnClickListener(new android.view.View.OnClickListener() {
							                    @Override public void onClick(android.view.View v) {
								                        android.content.Intent i = new android.content.Intent(StatsActivity.this, ReadingActivity.class);
								                        i.putExtra("surah_id", String.valueOf(sIdx + 1)); i.putExtra("target_start_ayah", startAyah); i.putExtra("target_end_ayah", endAyah); startActivity(i);
								                    }
							                });
						                btnDone.setOnClickListener(new android.view.View.OnClickListener() {
							                    @Override public void onClick(android.view.View v) {
								                        planData.edit().putInt("plan_" + planId + "_sessions", completedSessions + 1).apply();
								                        if(pType.equals("حفظ")) memoData.edit().putString("surah_" + (sIdx + 1) + "_saved", String.valueOf(endAyah)).apply();
								                        java.util.Calendar cl = java.util.Calendar.getInstance(); String dKey = "global_read_day_" + cl.get(java.util.Calendar.DAY_OF_YEAR);
								                        historyData.edit().putInt(dKey, historyData.getInt(dKey, 0) + todayTotalAyahs).apply(); 
								                        android.widget.Toast.makeText(getApplicationContext(), "تقبل الله! أتممت الورد بنجاح 👏", android.widget.Toast.LENGTH_SHORT).show(); 
								                        confettiHelper.shoot(); buildAll();
								                    }
							                });
						            } else { btnGo.setVisibility(android.view.View.GONE); btnDone.setVisibility(android.view.View.GONE); }
					            
					            btnReset.setOnClickListener(new android.view.View.OnClickListener() {
						                @Override public void onClick(android.view.View v) { actionDialog.show("إعادة الجدولة 🔄", "هل تريد البدء من جديد؟", "إعادة", "#FF9800", new Runnable(){ @Override public void run() { planData.edit().putInt("plan_" + planId + "_sessions", 0).apply(); refreshPlans(); } }); }
						            });
					            btnDel.setOnClickListener(new android.view.View.OnClickListener() {
						                @Override public void onClick(android.view.View v) { actionDialog.show("حذف الخطة 🗑️", "تأكيد الحذف نهائياً؟", "حذف", "#F44336", new Runnable(){ @Override public void run() { planData.edit().putBoolean("plan_" + planId + "_active", false).apply(); refreshPlans(); } }); }
						            });
					        }
				    }
		};
		
		uiBuilder.buildAll();
		
	}
	
	
	@Deprecated
	public void showMessage(String _s) {
		Toast.makeText(getApplicationContext(), _s, Toast.LENGTH_SHORT).show();
	}
	
	@Deprecated
	public int getLocationX(View _v) {
		int _location[] = new int[2];
		_v.getLocationInWindow(_location);
		return _location[0];
	}
	
	@Deprecated
	public int getLocationY(View _v) {
		int _location[] = new int[2];
		_v.getLocationInWindow(_location);
		return _location[1];
	}
	
	@Deprecated
	public int getRandom(int _min, int _max) {
		Random random = new Random();
		return random.nextInt(_max - _min + 1) + _min;
	}
	
	@Deprecated
	public ArrayList<Double> getCheckedItemPositionsToArray(ListView _list) {
		ArrayList<Double> _result = new ArrayList<Double>();
		SparseBooleanArray _arr = _list.getCheckedItemPositions();
		for (int _iIdx = 0; _iIdx < _arr.size(); _iIdx++) {
			if (_arr.valueAt(_iIdx))
			_result.add((double)_arr.keyAt(_iIdx));
		}
		return _result;
	}
	
	@Deprecated
	public float getDip(int _input) {
		return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, _input, getResources().getDisplayMetrics());
	}
	
	@Deprecated
	public int getDisplayWidthPixels() {
		return getResources().getDisplayMetrics().widthPixels;
	}
	
	@Deprecated
	public int getDisplayHeightPixels() {
		return getResources().getDisplayMetrics().heightPixels;
	}
}