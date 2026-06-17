package com.katma1.Quran1;

import android.animation.*;
import android.app.*;
import android.content.*;
import android.content.res.*;
import android.graphics.*;
import android.graphics.drawable.*;
import android.media.*;
import android.net.*;
import android.os.*;
import android.text.*;
import android.text.style.*;
import android.util.*;
import android.view.*;
import android.view.View.*;
import android.view.animation.*;
import android.webkit.*;
import android.widget.*;
import androidx.annotation.*;
import androidx.appcompat.app.AppCompatActivity;

import androidx.fragment.app.DialogFragment;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import java.io.*;
import java.text.*;
import java.util.*;
import java.util.regex.*;
import org.json.*;

public class MainActivity extends AppCompatActivity {
	
	@Override
	protected void onCreate(Bundle _savedInstanceState) {
		super.onCreate(_savedInstanceState);
		setContentView(R.layout.main);
		initialize(_savedInstanceState);
		initializeLogic();
	}
	
	private void initialize(Bundle _savedInstanceState) {
	}
	
	private void initializeLogic() {
		// ========================================================
		// 1. الإعدادات، الخطوط، والواجهة الغامرة (Immersive UI)
		// ========================================================
		final android.content.SharedPreferences prefs = getSharedPreferences("QuranPrefs", android.content.Context.MODE_PRIVATE);
		final android.content.SharedPreferences memoData = getSharedPreferences("memo_data", android.content.Context.MODE_PRIVATE);
		final boolean isDarkMode = prefs.getBoolean("dark_mode", false);
		final android.graphics.Typeface quranFont = android.graphics.Typeface.createFromAsset(getAssets(), "fonts/add.ttf");
		final float dp = getResources().getDisplayMetrics().density;
		
		getWindow().setSoftInputMode(android.view.WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
		if (android.os.Build.VERSION.SDK_INT >= 21) {
			    android.view.Window window = getWindow();
			    window.addFlags(android.view.WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
			    window.setStatusBarColor(isDarkMode ? android.graphics.Color.parseColor("#121212") : android.graphics.Color.parseColor("#FDF9F1"));
			    if (!isDarkMode && android.os.Build.VERSION.SDK_INT >= 23) {
				        window.getDecorView().setSystemUiVisibility(android.view.View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
				    }
		}
		
		if (android.os.Build.VERSION.SDK_INT >= 33) {
			    if (checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) != android.content.pm.PackageManager.PERMISSION_GRANTED) {
				        requestPermissions(new String[]{android.Manifest.permission.POST_NOTIFICATIONS}, 101);
				    }
		}
		
		final java.util.ArrayList<org.json.JSONObject> fullSurahList = new java.util.ArrayList<>();
		final java.util.ArrayList<org.json.JSONObject> filteredSurahList = new java.util.ArrayList<>();
		final java.util.ArrayList<String> allSurahNames = new java.util.ArrayList<>();
		final java.util.ArrayList<Integer> allSurahAyahs = new java.util.ArrayList<>();
		
		final String userName = prefs.getString("user_name", "");
		final boolean hasKhatma = prefs.getBoolean("has_khatma", false);
		java.util.Calendar calGreet = java.util.Calendar.getInstance();
		final int hour = calGreet.get(java.util.Calendar.HOUR_OF_DAY);
		
		int totalMemoAyatTemp = 0;
		for (int i = 1; i <= 114; i++) {
			    try { totalMemoAyatTemp += Integer.parseInt(memoData.getString("surah_" + i + "_saved", "0")); } catch(Exception e){}
		}
		final float progressPercent = ((float)totalMemoAyatTemp / 6236f) * 100f;
		
		// ========================================================
		// 2. كلاس الدائرة التفاعلية
		// ========================================================
		class CircleProgress extends android.view.View {
			    android.graphics.Paint bgPaint, progPaint, textPaint; float percent; String text; float strokeW;
			    public CircleProgress(android.content.Context c, float p, float strokeWidth, int tColor, boolean showText) {
				        super(c); this.percent = p > 100 ? 100 : p; this.strokeW = strokeWidth;
				        this.text = showText ? String.format(java.util.Locale.US, "%d%%", (int)percent) : "";
				        bgPaint = new android.graphics.Paint(android.graphics.Paint.ANTI_ALIAS_FLAG); bgPaint.setStyle(android.graphics.Paint.Style.STROKE); bgPaint.setStrokeWidth(strokeW);
				        bgPaint.setColor(isDarkMode ? android.graphics.Color.parseColor("#333333") : android.graphics.Color.parseColor("#E0E0E0")); 
				        progPaint = new android.graphics.Paint(android.graphics.Paint.ANTI_ALIAS_FLAG); progPaint.setStyle(android.graphics.Paint.Style.STROKE); progPaint.setStrokeWidth(strokeW); progPaint.setStrokeCap(android.graphics.Paint.Cap.ROUND); 
				        progPaint.setColor(percent == 100 ? android.graphics.Color.parseColor("#1976D2") : android.graphics.Color.parseColor("#4CAF50"));
				        textPaint = new android.graphics.Paint(android.graphics.Paint.ANTI_ALIAS_FLAG); textPaint.setColor(tColor); textPaint.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); textPaint.setTextAlign(android.graphics.Paint.Align.CENTER);
				    }
			    @Override protected void onDraw(android.graphics.Canvas canvas) {
				        super.onDraw(canvas); int size = Math.min(getWidth(), getHeight()); float pad = strokeW;
				        android.graphics.RectF rect = new android.graphics.RectF(pad, pad, size - pad, size - pad);
				        canvas.drawArc(rect, 0, 360, false, bgPaint); canvas.drawArc(rect, -90, (percent / 100f) * 360f, false, progPaint);
				        if(!text.isEmpty()) { textPaint.setTextSize(size / 3.5f); float yPos = (size / 2f) - ((textPaint.descent() + textPaint.ascent()) / 2f); canvas.drawText(text, size / 2f, yPos, textPaint); }
				    }
		}
		
		// ========================================================
		// 3. النوافذ المنبثقة (Dialogs)
		// ========================================================
		abstract class CustomDialogs { 
			    abstract void showName(); abstract void showCreateKhatma(); abstract void showKhatmaPlan(); 
			    abstract String getAyahLocation(int absoluteAyahIndex); 
			    abstract void showActionDialog(String title, String msg, String btnText, String colorHex, final Runnable onConfirm);
			    abstract void showAlarmDialog();
		}
		final CustomDialogs dialogs = new CustomDialogs() {
			    @Override void showName() {
				        final android.app.Dialog d = new android.app.Dialog(MainActivity.this); d.requestWindowFeature(android.view.Window.FEATURE_NO_TITLE);
				        android.widget.LinearLayout l = new android.widget.LinearLayout(MainActivity.this); l.setOrientation(android.widget.LinearLayout.VERTICAL); l.setPadding(60, 60, 60, 60);
				        android.graphics.drawable.GradientDrawable bg = new android.graphics.drawable.GradientDrawable(); bg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE); bg.setCornerRadius(50f); l.setBackground(bg);
				        android.widget.TextView t = new android.widget.TextView(MainActivity.this); t.setText("كيف نلقبك؟ 😊"); t.setTextSize(20); t.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.BLACK); t.setPadding(0,0,0,30);
				        final android.widget.EditText input = new android.widget.EditText(MainActivity.this); input.setHint("اكتب اسمك هنا.."); input.setText(userName);
				        android.widget.Button b = new android.widget.Button(MainActivity.this); b.setText("حفظ"); b.setTextColor(android.graphics.Color.WHITE);
				        android.graphics.drawable.GradientDrawable bb = new android.graphics.drawable.GradientDrawable(); bb.setColor(android.graphics.Color.parseColor("#2E7D32")); bb.setCornerRadius(30f); b.setBackground(bb);
				        l.addView(t); l.addView(input); l.addView(b); d.setContentView(l); d.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.TRANSPARENT)); d.show();
				        b.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { prefs.edit().putString("user_name", input.getText().toString().trim()).apply(); d.dismiss(); recreate(); } });
				    }
			
			    @Override void showCreateKhatma() {
				        final android.app.Dialog d = new android.app.Dialog(MainActivity.this); d.requestWindowFeature(android.view.Window.FEATURE_NO_TITLE);
				        android.widget.LinearLayout l = new android.widget.LinearLayout(MainActivity.this); l.setOrientation(android.widget.LinearLayout.VERTICAL); l.setPadding(60, 60, 60, 60);
				        android.graphics.drawable.GradientDrawable bg = new android.graphics.drawable.GradientDrawable(); bg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE); bg.setCornerRadius(50f); l.setBackground(bg);
				        android.widget.TextView t = new android.widget.TextView(MainActivity.this); t.setText("إضافة ختمة جديدة ✨"); t.setTextSize(20); t.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); t.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.BLACK); t.setPadding(0,0,0,20);
				        final android.widget.EditText eN = new android.widget.EditText(MainActivity.this); eN.setHint("اسم الختمة (مثال: ختمة رمضان)");
				        final android.widget.EditText eD = new android.widget.EditText(MainActivity.this); eD.setHint("المدة بالأيام (مثال: 30)"); eD.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
				        android.widget.Button b = new android.widget.Button(MainActivity.this); b.setText("حفظ وبدء الختمة"); b.setTextColor(android.graphics.Color.WHITE);
				        android.graphics.drawable.GradientDrawable bb = new android.graphics.drawable.GradientDrawable(); bb.setColor(android.graphics.Color.parseColor("#00796B")); bb.setCornerRadius(30f); android.widget.LinearLayout.LayoutParams bp = new android.widget.LinearLayout.LayoutParams(-1, -2); bp.setMargins(0,40,0,0); b.setLayoutParams(bp); b.setBackground(bb);
				        l.addView(t); l.addView(eN); l.addView(eD); l.addView(b); d.setContentView(l); d.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.TRANSPARENT)); d.show();
				        b.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) {
						            String ds = eD.getText().toString(); String ns = eN.getText().toString(); if(ns.isEmpty()) ns = "ختمة جديدة";
						            if(!ds.isEmpty()){ prefs.edit().putBoolean("has_khatma", true).putString("khatma_name", ns).putInt("khatma_days", Integer.parseInt(ds)).putFloat("khatma_progress", 0f).putLong("khatma_start_date", System.currentTimeMillis()).putInt("khatma_sessions_completed", 0).apply(); d.dismiss(); recreate(); }
						        }});
				    }
			
			    @Override void showActionDialog(String title, String msg, String btnText, String colorHex, final Runnable onConfirm) {
				        final android.app.Dialog d = new android.app.Dialog(MainActivity.this); d.requestWindowFeature(android.view.Window.FEATURE_NO_TITLE);
				        android.widget.LinearLayout l = new android.widget.LinearLayout(MainActivity.this); l.setOrientation(android.widget.LinearLayout.VERTICAL); l.setPadding(60, 60, 60, 60);
				        android.graphics.drawable.GradientDrawable bg = new android.graphics.drawable.GradientDrawable(); bg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE); bg.setCornerRadius(60f); l.setBackground(bg);
				        android.widget.TextView tvT = new android.widget.TextView(MainActivity.this); tvT.setText(title); tvT.setTextSize(22); tvT.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); tvT.setTextColor(android.graphics.Color.parseColor(colorHex)); tvT.setPadding(0,0,0,15);
				        android.widget.TextView tvM = new android.widget.TextView(MainActivity.this); tvM.setText(msg); tvM.setTextSize(15); tvM.setTextColor(android.graphics.Color.GRAY); tvM.setPadding(0,0,0,40);
				        android.widget.LinearLayout btns = new android.widget.LinearLayout(MainActivity.this); btns.setOrientation(android.widget.LinearLayout.HORIZONTAL);
				        android.widget.Button btnC = new android.widget.Button(MainActivity.this); btnC.setText("إلغاء"); btnC.setBackgroundColor(android.graphics.Color.TRANSPARENT); btnC.setTextColor(android.graphics.Color.GRAY); android.widget.LinearLayout.LayoutParams p1 = new android.widget.LinearLayout.LayoutParams(0, -2, 1f); btnC.setLayoutParams(p1);
				        android.widget.Button btnO = new android.widget.Button(MainActivity.this); btnO.setText(btnText); btnO.setTextColor(android.graphics.Color.WHITE); android.graphics.drawable.GradientDrawable obg = new android.graphics.drawable.GradientDrawable(); obg.setColor(android.graphics.Color.parseColor(colorHex)); obg.setCornerRadius(40f); btnO.setBackground(obg); android.widget.LinearLayout.LayoutParams p2 = new android.widget.LinearLayout.LayoutParams(0, -2, 1f); btnO.setLayoutParams(p2);
				        btns.addView(btnC); btns.addView(btnO); l.addView(tvT); l.addView(tvM); l.addView(btns);
				        btnC.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { d.dismiss(); } });
				        btnO.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { onConfirm.run(); d.dismiss(); } });
				        d.setContentView(l); d.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.TRANSPARENT)); d.show();
				    }
			
			    @Override String getAyahLocation(int absoluteAyahIndex) {
				        if(allSurahAyahs.isEmpty() || allSurahNames.isEmpty()) return "الآية " + absoluteAyahIndex;
				        int current = 0;
				        for(int i=0; i<allSurahAyahs.size(); i++) {
					            int verses = allSurahAyahs.get(i);
					            if(absoluteAyahIndex <= current + verses) { 
						                return "سورة " + allSurahNames.get(i) + " آية " + (absoluteAyahIndex - current); 
						            }
					            current += verses;
					        }
				        return "الناس 6";
				    }
			
			    @Override void showKhatmaPlan() {
				        if(!prefs.getBoolean("has_khatma", false) || allSurahAyahs.isEmpty()) return;
				        String kName = prefs.getString("khatma_name", "الختمة"); 
				        int kDays = prefs.getInt("khatma_days", 30);
				        long startDate = prefs.getLong("khatma_start_date", System.currentTimeMillis()); 
				        int completedSessions = prefs.getInt("khatma_sessions_completed", 0);
				        
				        final android.app.Dialog d = new android.app.Dialog(MainActivity.this); 
				        d.requestWindowFeature(android.view.Window.FEATURE_NO_TITLE);
				        android.widget.LinearLayout l = new android.widget.LinearLayout(MainActivity.this); 
				        l.setOrientation(android.widget.LinearLayout.VERTICAL); l.setPadding(50, 50, 50, 50);
				        android.graphics.drawable.GradientDrawable bg = new android.graphics.drawable.GradientDrawable(); 
				        bg.setColor(isDarkMode ? android.graphics.Color.parseColor("#1E1E1E") : android.graphics.Color.parseColor("#F5F5F5")); 
				        bg.setCornerRadius(40f); l.setBackground(bg);
				        
				        android.widget.TextView t = new android.widget.TextView(MainActivity.this); 
				        t.setText("تفاصيل: " + kName); t.setTextSize(22); t.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); 
				        t.setTextColor(android.graphics.Color.parseColor("#004D40")); t.setGravity(android.view.Gravity.CENTER); l.addView(t);
				        
				        android.widget.ScrollView s = new android.widget.ScrollView(MainActivity.this); 
				        s.setLayoutParams(new android.widget.LinearLayout.LayoutParams(-1, (int)(450 * dp)));
				        android.widget.LinearLayout c = new android.widget.LinearLayout(MainActivity.this); 
				        c.setOrientation(android.widget.LinearLayout.VERTICAL); c.setPadding(0, 30, 0, 0);
				        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd", java.util.Locale.US);
				        
				        int totalQuranAyahs = 6236; 
				        int totalPages = 604;
				        int ayahsPerDay = totalQuranAyahs / (kDays > 0 ? kDays : 1);
				        int pagesPerDay = totalPages / (kDays > 0 ? kDays : 1);
				
				        for(int i=0; i<kDays; i++){
					            java.util.Calendar cal = java.util.Calendar.getInstance(); 
					            cal.setTimeInMillis(startDate); cal.add(java.util.Calendar.DAY_OF_YEAR, i);
					            String dateStr = sdf.format(cal.getTime()); 
					            
					            int startAbs = (i * ayahsPerDay) + 1; 
					            int endAbs = (i == kDays - 1) ? totalQuranAyahs : (startAbs + ayahsPerDay - 1);
					            
					            int startPage = (i * pagesPerDay) + 1;
					            int endPage = (i == kDays - 1) ? totalPages : (startPage + pagesPerDay - 1);
					            
					            String planDetail = "من صفحة " + startPage + " " + getAyahLocation(startAbs) + 
					                                "\nإلى صفحة " + endPage + " " + getAyahLocation(endAbs);
					            
					            android.widget.LinearLayout rL = new android.widget.LinearLayout(MainActivity.this); 
					            rL.setOrientation(android.widget.LinearLayout.HORIZONTAL); rL.setGravity(android.view.Gravity.CENTER_VERTICAL); 
					            rL.setPadding(30, 30, 30, 30);
					            android.graphics.drawable.GradientDrawable itemBg = new android.graphics.drawable.GradientDrawable(); 
					            itemBg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE); 
					            itemBg.setCornerRadius(20f); rL.setBackground(itemBg);
					            android.widget.LinearLayout.LayoutParams rLp = new android.widget.LinearLayout.LayoutParams(-1, -2); 
					            rLp.setMargins(0, 0, 0, 20); rL.setLayoutParams(rLp);
					            
					            android.view.View iD = new android.view.View(MainActivity.this); 
					            android.graphics.drawable.GradientDrawable iBg = new android.graphics.drawable.GradientDrawable(); 
					            iBg.setShape(android.graphics.drawable.GradientDrawable.OVAL);
					            if(i < completedSessions) { iBg.setColor(android.graphics.Color.parseColor("#4CAF50")); } 
					            else { iBg.setColor(android.graphics.Color.TRANSPARENT); iBg.setStroke((int)(2*dp), android.graphics.Color.parseColor("#BDBDBD")); }
					            iD.setBackground(iBg); 
					            
					            android.widget.LinearLayout.LayoutParams dotP = new android.widget.LinearLayout.LayoutParams((int)(16*dp), (int)(16*dp)); 
					            dotP.setMargins(0, 0, (int)(15*dp), 0); iD.setLayoutParams(dotP);
					            android.widget.TextView dT = new android.widget.TextView(MainActivity.this); 
					            dT.setText("الورد " + (i+1) + " : " + dateStr + "\n" + planDetail); 
					            dT.setTextColor(isDarkMode ? android.graphics.Color.LTGRAY : android.graphics.Color.BLACK); dT.setTextSize(14);
					            rL.addView(iD); rL.addView(dT); c.addView(rL);
					        }
				        s.addView(c); l.addView(s); 
				        android.widget.Button bc = new android.widget.Button(MainActivity.this); 
				        bc.setText("إغلاق"); bc.setBackgroundColor(android.graphics.Color.TRANSPARENT); bc.setTextColor(android.graphics.Color.parseColor("#00796B")); 
				        l.addView(bc);
				        
				        d.setContentView(l); d.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.TRANSPARENT)); d.show();
				        bc.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { d.dismiss(); } });
				    }
			
			    @Override void showAlarmDialog() {
				        final android.app.Dialog d = new android.app.Dialog(MainActivity.this); d.requestWindowFeature(android.view.Window.FEATURE_NO_TITLE);
				        android.widget.LinearLayout l = new android.widget.LinearLayout(MainActivity.this); l.setOrientation(android.widget.LinearLayout.VERTICAL); l.setPadding(60, 40, 60, 60); l.setGravity(android.view.Gravity.CENTER);
				        android.graphics.drawable.GradientDrawable bg = new android.graphics.drawable.GradientDrawable(); bg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.parseColor("#FDF9F1")); bg.setCornerRadius(50f); l.setBackground(bg);
				        android.widget.TextView t = new android.widget.TextView(MainActivity.this); t.setText("⏰ ضبط منبه الورد"); t.setTextSize(22); t.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); t.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.parseColor("#8E24AA")); t.setPadding(0,0,0,40);
				        final android.widget.TimePicker tp = new android.widget.TimePicker(MainActivity.this); tp.setIs24HourView(false);
				        android.widget.Button b = new android.widget.Button(MainActivity.this); b.setText("حفظ التذكير الدقيق"); b.setTextColor(android.graphics.Color.WHITE);
				        android.graphics.drawable.GradientDrawable bb = new android.graphics.drawable.GradientDrawable(); bb.setColor(android.graphics.Color.parseColor("#8E24AA")); bb.setCornerRadius(30f); android.widget.LinearLayout.LayoutParams bp = new android.widget.LinearLayout.LayoutParams(-1, -2); bp.setMargins(0, 40, 0, 0); b.setLayoutParams(bp); b.setBackground(bb);
				        l.addView(t); l.addView(tp); l.addView(b); d.setContentView(l); d.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.TRANSPARENT)); d.show();
				        
				        b.setOnClickListener(new android.view.View.OnClickListener() { 
					            @Override public void onClick(android.view.View v) {
						                int h = (android.os.Build.VERSION.SDK_INT >= 23) ? tp.getHour() : tp.getCurrentHour(); 
						                int m = (android.os.Build.VERSION.SDK_INT >= 23) ? tp.getMinute() : tp.getCurrentMinute();
						                java.util.Calendar alarmTime = java.util.Calendar.getInstance(); 
						                alarmTime.set(java.util.Calendar.HOUR_OF_DAY, h); alarmTime.set(java.util.Calendar.MINUTE, m); alarmTime.set(java.util.Calendar.SECOND, 0); alarmTime.set(java.util.Calendar.MILLISECOND, 0);
						                if(alarmTime.before(java.util.Calendar.getInstance())) { alarmTime.add(java.util.Calendar.DATE, 1); }
						                
						                android.app.AlarmManager am = (android.app.AlarmManager) getSystemService(ALARM_SERVICE);
						                android.content.Intent i = new android.content.Intent(MainActivity.this, AlarmReceiver.class);
						                i.putExtra("hour", h); i.putExtra("minute", m);
						                android.app.PendingIntent pi = android.app.PendingIntent.getBroadcast(MainActivity.this, 0, i, android.app.PendingIntent.FLAG_UPDATE_CURRENT | (android.os.Build.VERSION.SDK_INT >= 23 ? android.app.PendingIntent.FLAG_IMMUTABLE : 0));
						                
						                if (am != null) {
							                    try {
								                        if (android.os.Build.VERSION.SDK_INT >= 31) {
									                            if (am.canScheduleExactAlarms()) {
										                                am.setExactAndAllowWhileIdle(android.app.AlarmManager.RTC_WAKEUP, alarmTime.getTimeInMillis(), pi);
										                            } else {
										                                am.setAndAllowWhileIdle(android.app.AlarmManager.RTC_WAKEUP, alarmTime.getTimeInMillis(), pi);
										                            }
									                        } else if (android.os.Build.VERSION.SDK_INT >= 23) {
									                            am.setExactAndAllowWhileIdle(android.app.AlarmManager.RTC_WAKEUP, alarmTime.getTimeInMillis(), pi);
									                        } else {
									                            am.setExact(android.app.AlarmManager.RTC_WAKEUP, alarmTime.getTimeInMillis(), pi);
									                        }
								                    } catch (Exception ex) {
								                        am.set(android.app.AlarmManager.RTC_WAKEUP, alarmTime.getTimeInMillis(), pi);
								                    }
							                }
						                
						                String timeFmt = String.format(java.util.Locale.US, "%02d:%02d", h, m);
						                android.widget.Toast.makeText(getApplicationContext(), "تم ضبط التذكير الدقيق ⏰ على " + timeFmt, android.widget.Toast.LENGTH_LONG).show(); d.dismiss();
						            }
					        });
				    }
		};
		
		// ========================================================
		// 4. بناء الواجهة (NestedScrollView)
		// ========================================================
		android.widget.LinearLayout rootMain = new android.widget.LinearLayout(this);
		rootMain.setOrientation(android.widget.LinearLayout.VERTICAL);
		rootMain.setBackgroundColor(isDarkMode ? android.graphics.Color.parseColor("#121212") : android.graphics.Color.parseColor("#FDF9F1"));
		rootMain.setLayoutParams(new android.view.ViewGroup.LayoutParams(-1, -1));
		
		androidx.core.widget.NestedScrollView mainScroll = new androidx.core.widget.NestedScrollView(this);
		mainScroll.setLayoutParams(new android.widget.LinearLayout.LayoutParams(-1, -1));
		
		android.widget.LinearLayout scrollContent = new android.widget.LinearLayout(this);
		scrollContent.setOrientation(android.widget.LinearLayout.VERTICAL);
		scrollContent.setPadding(40, (int)(60*dp), 40, (int)(80*dp));
		
		android.widget.RelativeLayout topBar = new android.widget.RelativeLayout(this); topBar.setPadding(0, 0, 0, 30);
		android.widget.Button btnTheme = new android.widget.Button(this); btnTheme.setText(isDarkMode ? "☀️" : "🌙");
		android.graphics.drawable.GradientDrawable themeBg = new android.graphics.drawable.GradientDrawable(); themeBg.setShape(android.graphics.drawable.GradientDrawable.OVAL); themeBg.setColor(isDarkMode ? android.graphics.Color.parseColor("#333333") : android.graphics.Color.parseColor("#E8E0C5"));
		btnTheme.setBackground(themeBg); android.widget.RelativeLayout.LayoutParams themeP = new android.widget.RelativeLayout.LayoutParams((int)(40*dp), (int)(40*dp)); themeP.addRule(android.widget.RelativeLayout.ALIGN_PARENT_LEFT); btnTheme.setLayoutParams(themeP);
		btnTheme.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { prefs.edit().putBoolean("dark_mode", !isDarkMode).apply(); recreate(); } });
		topBar.addView(btnTheme); scrollContent.addView(topBar);
		
		android.widget.LinearLayout headerRow = new android.widget.LinearLayout(this); headerRow.setOrientation(android.widget.LinearLayout.HORIZONTAL); headerRow.setGravity(android.view.Gravity.CENTER_VERTICAL); headerRow.setPadding(0, 20, 0, 40); headerRow.setClickable(true); headerRow.setFocusable(true);
		android.widget.LinearLayout greetL = new android.widget.LinearLayout(this); greetL.setOrientation(android.widget.LinearLayout.VERTICAL); greetL.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, -2, 1f));
		String greetingPrefix = (hour >= 5 && hour < 12) ? "صباح الخير" : (hour >= 12 && hour < 17) ? "طاب يومك" : "مساء الخير";
		android.widget.TextView tvG = new android.widget.TextView(this); tvG.setText(greetingPrefix + (userName.isEmpty() ? "" : " " + userName) + " ✨"); tvG.setTextSize(24); tvG.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.parseColor("#2E7D32")); tvG.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
		android.widget.TextView tvS = new android.widget.TextView(this); tvS.setText(userName.isEmpty() ? "اضغط هنا لكتابة اسمك.." : "مرحباً بك في تطبيق ختمة"); tvS.setTextSize(13); tvS.setTextColor(android.graphics.Color.GRAY);
		greetL.addView(tvG); greetL.addView(tvS);
		CircleProgress mc = new CircleProgress(this, progressPercent, 15f, isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.parseColor("#2E7D32"), true); mc.setLayoutParams(new android.widget.LinearLayout.LayoutParams((int)(80*dp), (int)(80*dp)));
		headerRow.addView(greetL); headerRow.addView(mc); scrollContent.addView(headerRow);
		greetL.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { dialogs.showName(); } });
		mc.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { startActivity(new android.content.Intent(MainActivity.this, StatsActivity.class)); } });
		
		if (!hasKhatma) {
			    android.widget.Button btnAddKhatma = new android.widget.Button(this);
			    btnAddKhatma.setText("إنشاء ختمة جديدة ➕");
			    btnAddKhatma.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.parseColor("#00796B"));
			    android.graphics.drawable.GradientDrawable addBg = new android.graphics.drawable.GradientDrawable();
			    addBg.setColor(android.graphics.Color.TRANSPARENT);
			    addBg.setStroke(3, android.graphics.Color.parseColor("#00796B"));
			    addBg.setCornerRadius(30f);
			    btnAddKhatma.setBackground(addBg);
			    android.widget.LinearLayout.LayoutParams addParams = new android.widget.LinearLayout.LayoutParams(-1, -2);
			    addParams.setMargins(0, 0, 0, 40);
			    btnAddKhatma.setLayoutParams(addParams);
			    
			    scrollContent.addView(btnAddKhatma);
			    
			    btnAddKhatma.setOnClickListener(new android.view.View.OnClickListener() {
				        @Override public void onClick(android.view.View v) { dialogs.showCreateKhatma(); }
				    });
		} else {
			    String khatmaName = prefs.getString("khatma_name", "متابعة الختمة");
			    float kProgress = prefs.getFloat("khatma_progress", 0f);
			    
			    android.widget.LinearLayout resumeCard = new android.widget.LinearLayout(this);
			    resumeCard.setOrientation(android.widget.LinearLayout.HORIZONTAL);
			    resumeCard.setPadding(40, 40, 40, 40);
			    resumeCard.setElevation(15f);
			    resumeCard.setGravity(android.view.Gravity.CENTER_VERTICAL);
			    android.graphics.drawable.GradientDrawable rBg = new android.graphics.drawable.GradientDrawable();
			    rBg.setColor(android.graphics.Color.parseColor("#004D40")); 
			    rBg.setCornerRadius(30f); 
			    resumeCard.setBackground(rBg);
			    android.widget.LinearLayout.LayoutParams rParams = new android.widget.LinearLayout.LayoutParams(-1, -2);
			    rParams.setMargins(0, 0, 0, 40); 
			    resumeCard.setLayoutParams(rParams);
			
			    CircleProgress khatmaCircle = new CircleProgress(this, kProgress, 8f, android.graphics.Color.WHITE, true);
			    khatmaCircle.setLayoutParams(new android.widget.LinearLayout.LayoutParams((int)(60 * dp), (int)(60 * dp)));
			    resumeCard.addView(khatmaCircle);
			
			    android.widget.LinearLayout rTextLayout = new android.widget.LinearLayout(this);
			    rTextLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
			    android.widget.LinearLayout.LayoutParams txtParams = new android.widget.LinearLayout.LayoutParams(0, -2, 1f);
			    txtParams.setMargins(30, 0, 10, 0);
			    rTextLayout.setLayoutParams(txtParams);
			
			    android.widget.TextView rTitle = new android.widget.TextView(this);
			    rTitle.setText("متابعة الختمة 📖"); 
			    rTitle.setTextColor(android.graphics.Color.WHITE);
			    rTitle.setTextSize(18); 
			    rTitle.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
			
			    android.widget.TextView rDesc = new android.widget.TextView(this);
			    rDesc.setText(khatmaName); 
			    rDesc.setTextColor(android.graphics.Color.parseColor("#B2DFDB"));
			    rDesc.setTextSize(14); 
			
			    // الحساب الدقيق للمواظبة والتأخير والتقدم
			    long startDate = prefs.getLong("khatma_start_date", System.currentTimeMillis());
			    int daysPassed = (int)((System.currentTimeMillis() - startDate) / (1000 * 60 * 60 * 24));
			    int completedSessions = prefs.getInt("khatma_sessions_completed", 0);
			    
			    // ==========================================
			    // حساب الورد الفعلي وتحديث الويدجت تلقائياً
			    // ==========================================
			    int kDays = prefs.getInt("khatma_days", 30);
			    int pagesPerDay = 604 / (kDays > 0 ? kDays : 1);
			    int targetWirdNum = completedSessions + 1;
			    int startPage = (completedSessions * pagesPerDay) + 1;
			    int endPage = Math.min((targetWirdNum * pagesPerDay), 604);
			
			    String myWirdString = "الورد رقم (" + targetWirdNum + ")\nمن صفحة " + startPage + " إلى صفحة " + endPage;
			    prefs.edit().putString("current_wird_text", myWirdString).apply();
			
			    try {
				        android.content.Intent widgetIntent = new android.content.Intent(MainActivity.this, Class.forName(getPackageName() + ".KhatmaWidgetProvider"));
				        widgetIntent.setAction(android.appwidget.AppWidgetManager.ACTION_APPWIDGET_UPDATE);
				        int[] widgetIds = android.appwidget.AppWidgetManager.getInstance(getApplication())
				            .getAppWidgetIds(new android.content.ComponentName(getApplication(), widgetIntent.getComponent().getClassName()));
				        widgetIntent.putExtra(android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_IDS, widgetIds);
				        sendBroadcast(widgetIntent);
				    } catch(Exception e) {}
			    // ==========================================
			
			    int diff = completedSessions - daysPassed;
			    int dotColor = android.graphics.Color.parseColor("#4CAF50");
			    String statusTextStr = " مواظب على الورد";
			
			    if (diff == 0) {
				        dotColor = android.graphics.Color.parseColor("#4CAF50"); 
				        statusTextStr = " مواظب على الورد";
				    } else if (diff < 0) {
				        int lateCount = Math.abs(diff);
				        dotColor = android.graphics.Color.parseColor("#F44336"); 
				        if (lateCount == 1) statusTextStr = " متأخر جلسة واحدة";
				        else if (lateCount == 2) statusTextStr = " متأخر جلستين";
				        else statusTextStr = " متأخر " + lateCount + " جلسات";
				    } else {
				        int aheadCount = diff;
				        dotColor = android.graphics.Color.parseColor("#2196F3"); 
				        if (aheadCount == 1) statusTextStr = " متقدم جلسة واحدة";
				        else if (aheadCount == 2) statusTextStr = " متقدم جلستين";
				        else statusTextStr = " متقدم " + aheadCount + " جلسات";
				    }
			
			    android.widget.LinearLayout statusLayout = new android.widget.LinearLayout(this);
			    statusLayout.setOrientation(android.widget.LinearLayout.HORIZONTAL);
			    statusLayout.setGravity(android.view.Gravity.CENTER_VERTICAL);
			    statusLayout.setPadding(0, 10, 0, 0);
			
			    android.view.View statusDot = new android.view.View(this);
			    android.graphics.drawable.GradientDrawable dotBg = new android.graphics.drawable.GradientDrawable();
			    dotBg.setShape(android.graphics.drawable.GradientDrawable.OVAL);
			    dotBg.setColor(dotColor); 
			    statusDot.setBackground(dotBg);
			    statusDot.setLayoutParams(new android.widget.LinearLayout.LayoutParams((int)(10*dp), (int)(10*dp)));
			
			    android.widget.TextView statusText = new android.widget.TextView(this);
			    statusText.setText(statusTextStr);
			    statusText.setTextColor(android.graphics.Color.parseColor("#E8F5E9"));
			    statusText.setTextSize(12);
			    statusText.setPadding(10, 0, 0, 0);
			    statusLayout.addView(statusDot); statusLayout.addView(statusText);
			
			    rTextLayout.addView(rTitle); rTextLayout.addView(rDesc); rTextLayout.addView(statusLayout);
			    resumeCard.addView(rTextLayout);
			
			    android.widget.GridLayout buttonsGrid = new android.widget.GridLayout(this);
			    buttonsGrid.setColumnCount(2); buttonsGrid.setRowCount(2);
			    
			    class CardBtnBuilder {
				        android.widget.ImageView create(int resId, String fallbackIconName) {
					            android.widget.ImageView btn = new android.widget.ImageView(MainActivity.this);
					            int imgId = getResources().getIdentifier(fallbackIconName, "drawable", getPackageName());
					            if(imgId != 0) { btn.setImageResource(imgId); } else { btn.setImageResource(resId); }
					            btn.setColorFilter(android.graphics.Color.WHITE);
					            btn.setPadding(15, 15, 15, 15);
					            android.graphics.drawable.GradientDrawable bg = new android.graphics.drawable.GradientDrawable();
					            bg.setShape(android.graphics.drawable.GradientDrawable.OVAL);
					            bg.setColor(android.graphics.Color.parseColor("#26FFFFFF"));
					            btn.setBackground(bg);
					            android.widget.GridLayout.LayoutParams p = new android.widget.GridLayout.LayoutParams();
					            p.width = (int)(35*dp); p.height = (int)(35*dp);
					            p.setMargins(10, 10, 10, 10);
					            btn.setLayoutParams(p);
					            return btn;
					        }
				    }
			    CardBtnBuilder cbb = new CardBtnBuilder();
			    android.widget.ImageView btnInfo = cbb.create(android.R.drawable.ic_dialog_info, "ic_khatma_info");
			    android.widget.ImageView btnAddKhatma = cbb.create(android.R.drawable.ic_input_add, "ic_khatma_add");
			    android.widget.ImageView btnReset = cbb.create(android.R.drawable.ic_popup_sync, "ic_khatma_reset"); 
			    android.widget.ImageView btnDelete = cbb.create(android.R.drawable.ic_menu_delete, "ic_khatma_delete"); 
			    
			    buttonsGrid.addView(btnInfo); buttonsGrid.addView(btnAddKhatma);
			    buttonsGrid.addView(btnReset); buttonsGrid.addView(btnDelete);
			    resumeCard.addView(buttonsGrid);
			    
			    scrollContent.addView(resumeCard);
			
			    resumeCard.setOnClickListener(new android.view.View.OnClickListener() {
				        @Override public void onClick(android.view.View v) {
					            android.content.Intent intent = new android.content.Intent(MainActivity.this, ReadingActivity.class);
					            intent.putExtra("continue_khatma", true); startActivity(intent); 
					        }
				    });
			    btnAddKhatma.setOnClickListener(new android.view.View.OnClickListener() {
				        @Override public void onClick(android.view.View v) { dialogs.showCreateKhatma(); }
				    });
			    btnInfo.setOnClickListener(new android.view.View.OnClickListener() {
				        @Override public void onClick(android.view.View v) { dialogs.showKhatmaPlan(); }
				    });
			    btnReset.setOnClickListener(new android.view.View.OnClickListener() {
				        @Override public void onClick(android.view.View v) {
					            dialogs.showActionDialog("إعادة الختمة 🔄", "هل أنت متأكد من تصفير التقدم والبدء من جديد؟", "إعادة", "#FF9800", new Runnable(){ 
						                @Override public void run(){ prefs.edit().putFloat("khatma_progress", 0f).putInt("khatma_sessions_completed", 0).putInt("last_read_page_index", 0).apply(); recreate(); }
						            });
					        }
				    });
			    btnDelete.setOnClickListener(new android.view.View.OnClickListener() {
				        @Override public void onClick(android.view.View v) {
					            dialogs.showActionDialog("حذف الختمة 🗑️", "هل أنت متأكد من مسح الختمة نهائياً؟", "حذف نهائي", "#F44336", new Runnable(){ 
						                @Override public void run(){ prefs.edit().putBoolean("has_khatma", false).apply(); recreate(); }
						            });
					        }
				    });
		}
		
		android.widget.LinearLayout g1 = new android.widget.LinearLayout(this); g1.setWeightSum(2);
		abstract class BtnB { abstract android.widget.LinearLayout make(String i, String t, String c, final Class<?> cls); }
		BtnB bb = new BtnB() {
			    @Override android.widget.LinearLayout make(String i, String t, String c, final Class<?> cls) {
				        android.widget.LinearLayout l = new android.widget.LinearLayout(MainActivity.this); l.setOrientation(android.widget.LinearLayout.VERTICAL); l.setPadding(10, 30, 10, 30); l.setGravity(android.view.Gravity.CENTER);
				        l.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, -2, 1f)); ((android.widget.LinearLayout.LayoutParams)l.getLayoutParams()).setMargins(10,10,10,10);
				        android.graphics.drawable.GradientDrawable b = new android.graphics.drawable.GradientDrawable(); b.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE); b.setCornerRadius(25f); l.setBackground(b); l.setElevation(10f);
				        android.widget.TextView ti = new android.widget.TextView(MainActivity.this); ti.setText(i); ti.setTextSize(26);
				        android.widget.TextView tt = new android.widget.TextView(MainActivity.this); tt.setText(t); tt.setTextSize(12); tt.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.parseColor(c)); tt.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
				        l.addView(ti); l.addView(tt);
				        l.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { if(cls != null) startActivity(new android.content.Intent(MainActivity.this, cls)); else dialogs.showAlarmDialog(); } });
				        return l;
				    }
		};
		g1.addView(bb.make("📊", "لوحة المتابعة", "#E64A19", StatsActivity.class));
		g1.addView(bb.make("🔍", "البحث الذكي", "#1976D2", SearchActivity.class));
		scrollContent.addView(g1);
		android.widget.LinearLayout g2 = new android.widget.LinearLayout(this); g2.setWeightSum(2); g2.setPadding(0,0,0,40);
		g2.addView(bb.make("⭐", "المفضلة", "#FBC02D", BookmarksActivity.class));
		g2.addView(bb.make("⏰", "تذكير الورد", "#8E24AA", null)); 
		scrollContent.addView(g2);
		
		final android.widget.RelativeLayout iH = new android.widget.RelativeLayout(this); iH.setPadding(10, 20, 10, 20);
		android.widget.TextView tI = new android.widget.TextView(this); tI.setText("فهرس السور 📜"); tI.setTextSize(20); tI.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); tI.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.parseColor("#2E7D32"));
		final android.widget.TextView btnSearch = new android.widget.TextView(this); btnSearch.setText("🔍"); btnSearch.setTextSize(22);
		android.widget.RelativeLayout.LayoutParams sP = new android.widget.RelativeLayout.LayoutParams(-2, -2); sP.addRule(android.widget.RelativeLayout.ALIGN_PARENT_LEFT); btnSearch.setLayoutParams(sP);
		iH.addView(tI); iH.addView(btnSearch); scrollContent.addView(iH);
		
		final android.widget.LinearLayout searchBar = new android.widget.LinearLayout(this); searchBar.setOrientation(android.widget.LinearLayout.HORIZONTAL); searchBar.setPadding(30, 15, 30, 15); searchBar.setVisibility(android.view.View.GONE);
		android.graphics.drawable.GradientDrawable sBg = new android.graphics.drawable.GradientDrawable(); sBg.setColor(isDarkMode ? android.graphics.Color.parseColor("#1E1E1E") : android.graphics.Color.WHITE); sBg.setCornerRadius(40f); searchBar.setBackground(sBg); searchBar.setElevation(15f);
		android.widget.LinearLayout.LayoutParams sbParams = new android.widget.LinearLayout.LayoutParams(-1, -2); sbParams.setMargins(10, 10, 10, 30); searchBar.setLayoutParams(sbParams);
		final android.widget.EditText et = new android.widget.EditText(this); et.setHint("ابحث عن سورة..."); et.setBackgroundColor(android.graphics.Color.TRANSPARENT); et.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, -2, 1f));
		android.widget.TextView cl = new android.widget.TextView(this); cl.setText("✕"); cl.setTextColor(android.graphics.Color.RED); cl.setPadding(20, 10, 20, 10);
		searchBar.addView(et); searchBar.addView(cl); scrollContent.addView(searchBar);
		
		final androidx.recyclerview.widget.RecyclerView rv = new androidx.recyclerview.widget.RecyclerView(this);
		rv.setLayoutManager(new androidx.recyclerview.widget.LinearLayoutManager(this)); 
		rv.setPadding(10, 0, 10, 40); rv.setClipToPadding(false); rv.setNestedScrollingEnabled(false); 
		scrollContent.addView(rv);
		
		mainScroll.addView(scrollContent); rootMain.addView(mainScroll);
		setContentView(rootMain);
		
		abstract class SAdapter extends androidx.recyclerview.widget.RecyclerView.Adapter<androidx.recyclerview.widget.RecyclerView.ViewHolder> {}
		final SAdapter adapter = new SAdapter() {
			    class H extends androidx.recyclerview.widget.RecyclerView.ViewHolder {
				        android.widget.TextView n, i, u; CircleProgress c; android.widget.LinearLayout r;
				        public H(android.view.View v) { super(v); r = (android.widget.LinearLayout)v; u = (android.widget.TextView)r.getChildAt(0); android.widget.LinearLayout l = (android.widget.LinearLayout)r.getChildAt(1); n = (android.widget.TextView)l.getChildAt(0); i = (android.widget.TextView)l.getChildAt(1); c = (CircleProgress)r.getChildAt(2); }
				    }
			    @Override public androidx.recyclerview.widget.RecyclerView.ViewHolder onCreateViewHolder(android.view.ViewGroup p, int t) {
				        android.widget.LinearLayout r = new android.widget.LinearLayout(MainActivity.this); r.setPadding(30, 35, 30, 35); r.setGravity(android.view.Gravity.CENTER_VERTICAL);
				        android.graphics.drawable.GradientDrawable rb = new android.graphics.drawable.GradientDrawable(); rb.setColor(isDarkMode ? android.graphics.Color.parseColor("#1E1E1E") : android.graphics.Color.parseColor("#F5F0E6")); rb.setCornerRadius(25f); r.setBackground(rb);
				        androidx.recyclerview.widget.RecyclerView.LayoutParams lp = new androidx.recyclerview.widget.RecyclerView.LayoutParams(-1, -2); lp.setMargins(0, 0, 0, 15); r.setLayoutParams(lp);
				        android.widget.TextView tn = new android.widget.TextView(MainActivity.this); tn.setLayoutParams(new android.widget.LinearLayout.LayoutParams((int)(35*dp), (int)(35*dp))); tn.setGravity(android.view.Gravity.CENTER); tn.setTextSize(12); tn.setTextColor(android.graphics.Color.parseColor("#388E3C"));
				        android.graphics.drawable.GradientDrawable nb = new android.graphics.drawable.GradientDrawable(); nb.setShape(android.graphics.drawable.GradientDrawable.OVAL); nb.setColor(isDarkMode ? android.graphics.Color.parseColor("#333333") : android.graphics.Color.WHITE); tn.setBackground(nb);
				        android.widget.LinearLayout il = new android.widget.LinearLayout(MainActivity.this); il.setOrientation(android.widget.LinearLayout.VERTICAL); il.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, -2, 1f)); il.setPadding(25, 0, 25, 0);
				        android.widget.TextView ts = new android.widget.TextView(MainActivity.this); ts.setTextSize(17); ts.setTypeface(quranFont); ts.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.BLACK);
				        android.widget.TextView ta = new android.widget.TextView(MainActivity.this); ta.setTextSize(11); il.addView(ts); il.addView(ta);
				        CircleProgress cp = new CircleProgress(MainActivity.this, 0, 6f, android.graphics.Color.GRAY, false); cp.setLayoutParams(new android.widget.LinearLayout.LayoutParams((int)(25*dp), (int)(25*dp)));
				        android.widget.TextView aw = new android.widget.TextView(MainActivity.this); aw.setText("❯"); aw.setTextColor(android.graphics.Color.parseColor("#388E3C"));
				        r.addView(tn); r.addView(il); r.addView(cp); r.addView(aw); return new H(r);
				    }
			    @Override public void onBindViewHolder(androidx.recyclerview.widget.RecyclerView.ViewHolder h, int p) {
				        final H holder = (H)h; try {
					            final org.json.JSONObject s = filteredSurahList.get(p); final int id = s.getInt("id"); int tv = s.getInt("total_verses"); int sv = Integer.parseInt(memoData.getString("surah_" + id + "_saved", "0"));
					            float per = tv > 0 ? ((float)sv / tv) * 100f : 0f;
					            holder.u.setText(String.valueOf(id)); holder.n.setText(s.getString("name"));
					            if (sv > 0 && sv < tv) { holder.i.setText("حفظت " + sv + " آية من أصل " + tv + " (" + (int)per + "%)"); holder.i.setTextColor(android.graphics.Color.parseColor("#E64A19")); } 
					            else if (sv == tv && tv > 0) { holder.i.setText("مكتملة الحفظ (" + tv + " آيات)"); holder.i.setTextColor(android.graphics.Color.parseColor("#1976D2")); } 
					            else { holder.i.setText("آياتها: " + tv + " | لم تبدأ الحفظ"); holder.i.setTextColor(android.graphics.Color.GRAY); }
					            holder.c.percent = per; holder.c.invalidate();
					            holder.r.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { startActivity(new android.content.Intent(MainActivity.this, ReadingActivity.class).putExtra("surah_id", String.valueOf(id))); } });
					        } catch(Exception e){}
				    }
			    @Override public int getItemCount() { return filteredSurahList.size(); }
		};
		rv.setAdapter(adapter);
		
		new Thread(new Runnable() { @Override public void run() { try {
					    java.io.InputStream is = getAssets().open("index.json"); java.util.Scanner sc = new java.util.Scanner(is).useDelimiter("\\A");
					    org.json.JSONArray arr = new org.json.JSONArray(sc.hasNext() ? sc.next() : "");
					    for(int i=0; i<arr.length(); i++) { org.json.JSONObject o = arr.getJSONObject(i); o.put("id", i+1); fullSurahList.add(o); allSurahNames.add(o.has("name")?o.getString("name"):"سورة "+(i+1)); allSurahAyahs.add(o.has("total_verses")?o.getInt("total_verses"):0); }
					    filteredSurahList.addAll(fullSurahList); runOnUiThread(new Runnable() { @Override public void run() { adapter.notifyDataSetChanged(); } });
				} catch(Exception e){} } }).start();
		
		btnSearch.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { btnSearch.setVisibility(android.view.View.GONE); searchBar.setVisibility(android.view.View.VISIBLE); et.requestFocus(); android.view.inputmethod.InputMethodManager imm = (android.view.inputmethod.InputMethodManager) getSystemService(android.content.Context.INPUT_METHOD_SERVICE); imm.showSoftInput(et, android.view.inputmethod.InputMethodManager.SHOW_IMPLICIT); } });
		cl.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { et.setText(""); searchBar.setVisibility(android.view.View.GONE); btnSearch.setVisibility(android.view.View.VISIBLE); android.view.inputmethod.InputMethodManager imm = (android.view.inputmethod.InputMethodManager) getSystemService(android.content.Context.INPUT_METHOD_SERVICE); imm.hideSoftInputFromWindow(et.getWindowToken(), 0); } });
		et.addTextChangedListener(new android.text.TextWatcher() {
			    @Override public void onTextChanged(CharSequence s, int st, int b, int c) { filteredSurahList.clear(); String q = s.toString().trim();
				        for(org.json.JSONObject o : fullSurahList) { try { if(o.getString("name").contains(q)) filteredSurahList.add(o); } catch(Exception e){} } adapter.notifyDataSetChanged(); }
			    @Override public void beforeTextChanged(CharSequence s, int st, int b, int c) {} @Override public void afterTextChanged(android.text.Editable s) {}
		});
		
		// ========================================================
		// 6. كلاس المنبه العام
		// ========================================================
	} // إغلاق دالة onCreate
	
	public static class AlarmReceiver extends android.content.BroadcastReceiver {
		    @Override public void onReceive(android.content.Context context, android.content.Intent intent) {
			        // 1. إعداد قناة الإشعار
			        String cid = "quran_reminder";
			        android.app.NotificationManager nm = (android.app.NotificationManager) context.getSystemService(android.content.Context.NOTIFICATION_SERVICE);
			        if (android.os.Build.VERSION.SDK_INT >= 26) {
				            android.app.NotificationChannel channel = new android.app.NotificationChannel(cid, "تذكير الورد", android.app.NotificationManager.IMPORTANCE_HIGH);
				            if (nm != null) nm.createNotificationChannel(channel);
				        }
			
			        // 2. إعداد الضغط على الإشعار لفتح التطبيق
			        android.content.Intent appIntent = new android.content.Intent(context, com.katma1.Quran1.MainActivity.class);
			        int flags = android.app.PendingIntent.FLAG_UPDATE_CURRENT;
			        if (android.os.Build.VERSION.SDK_INT >= 23) flags |= android.app.PendingIntent.FLAG_IMMUTABLE;
			        android.app.PendingIntent pi = android.app.PendingIntent.getActivity(context, 0, appIntent, flags);
			
			        // 3. بناء الإشعار
			        android.app.Notification.Builder nb = (android.os.Build.VERSION.SDK_INT >= 26) ? new android.app.Notification.Builder(context, cid) : new android.app.Notification.Builder(context);
			        nb.setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
			          .setContentTitle("حان وقت وردك القرآني 📖")
			          .setContentText("لا تهجر مصحفك، افتح التطبيق الآن لتكمل حفظك.")
			          .setContentIntent(pi)
			          .setAutoCancel(true)
			          .setPriority(android.app.Notification.PRIORITY_HIGH);
			        
			        if (nm != null) nm.notify(101, nb.build());
			
			        // 4. إعادة جدولة المنبه لليوم التالي تلقائياً لضمان الاستمرارية
			        int h = intent.getIntExtra("hour", 8);
			        int m = intent.getIntExtra("minute", 0);
			        java.util.Calendar next = java.util.Calendar.getInstance();
			        next.set(java.util.Calendar.HOUR_OF_DAY, h);
			        next.set(java.util.Calendar.MINUTE, m);
			        next.set(java.util.Calendar.SECOND, 0);
			        next.add(java.util.Calendar.DATE, 1);
			
			        android.app.AlarmManager am = (android.app.AlarmManager) context.getSystemService(android.content.Context.ALARM_SERVICE);
			        android.content.Intent ni = new android.content.Intent(context, AlarmReceiver.class);
			        ni.putExtra("hour", h); ni.putExtra("minute", m);
			        android.app.PendingIntent npi = android.app.PendingIntent.getBroadcast(context, 0, ni, flags);
			
			        if (am != null) {
				            try {
					                if (android.os.Build.VERSION.SDK_INT >= 23) {
						                    am.setExactAndAllowWhileIdle(android.app.AlarmManager.RTC_WAKEUP, next.getTimeInMillis(), npi);
						                } else {
						                    am.setExact(android.app.AlarmManager.RTC_WAKEUP, next.getTimeInMillis(), npi);
						                }
					            } catch (Exception e) { am.set(android.app.AlarmManager.RTC_WAKEUP, next.getTimeInMillis(), npi); }
				        }
			    }
	}
	
	private void dummy() { 
		
	}
	
	@Override
	public void onStart() {
		super.onStart();
		
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