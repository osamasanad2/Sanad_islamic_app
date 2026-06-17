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

public class BookmarksActivity extends AppCompatActivity {
	
	@Override
	protected void onCreate(Bundle _savedInstanceState) {
		super.onCreate(_savedInstanceState);
		setContentView(R.layout.bookmarks);
		initialize(_savedInstanceState);
		initializeLogic();
	}
	
	private void initialize(Bundle _savedInstanceState) {
	}
	
	private void initializeLogic() {
		// ========================================================
		// 1. الإعدادات الأساسية
		// ========================================================
		final android.content.SharedPreferences prefs = getSharedPreferences("QuranPrefs", android.content.Context.MODE_PRIVATE);
		final android.content.SharedPreferences bookmarksData = getSharedPreferences("bookmarks_data", android.content.Context.MODE_PRIVATE);
		final boolean isDarkMode = prefs.getBoolean("dark_mode", false);
		final android.graphics.Typeface quranFont = android.graphics.Typeface.createFromAsset(getAssets(), "fonts/add.ttf");
		final float dp = getResources().getDisplayMetrics().density;
		
		// ========================================================
		// 2. الواجهة الأساسية
		// ========================================================
		android.widget.ScrollView scroll = new android.widget.ScrollView(this);
		scroll.setBackgroundColor(isDarkMode ? android.graphics.Color.parseColor("#121212") : android.graphics.Color.parseColor("#FDF9F1"));
		scroll.setLayoutParams(new android.view.ViewGroup.LayoutParams(-1, -1));
		
		final android.widget.LinearLayout mainLayout = new android.widget.LinearLayout(this);
		mainLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
		mainLayout.setPadding(30, 60, 30, 60);
		scroll.addView(mainLayout);
		
		// -- شريط العنوان الأنيق --
		android.widget.RelativeLayout topBar = new android.widget.RelativeLayout(this);
		topBar.setPadding(0, 0, 0, 40);
		
		android.widget.TextView btnBack = new android.widget.TextView(this);
		btnBack.setText("❮"); btnBack.setTextSize(24); btnBack.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
		btnBack.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.BLACK); btnBack.setPadding(20, 10, 20, 10);
		android.widget.RelativeLayout.LayoutParams backParams = new android.widget.RelativeLayout.LayoutParams(-2, -2);
		backParams.addRule(android.widget.RelativeLayout.ALIGN_PARENT_LEFT); backParams.addRule(android.widget.RelativeLayout.CENTER_VERTICAL);
		btnBack.setLayoutParams(backParams);
		btnBack.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { finish(); } });
		
		android.widget.TextView tvTitle = new android.widget.TextView(this);
		tvTitle.setText("الآيات المفضلة ⭐");
		tvTitle.setTextSize(22);
		tvTitle.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.parseColor("#388E3C"));
		tvTitle.setGravity(android.view.Gravity.CENTER);
		tvTitle.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
		android.widget.RelativeLayout.LayoutParams titleParams = new android.widget.RelativeLayout.LayoutParams(-2, -2);
		titleParams.addRule(android.widget.RelativeLayout.CENTER_IN_PARENT); tvTitle.setLayoutParams(titleParams);
		
		topBar.addView(btnBack); topBar.addView(tvTitle);
		mainLayout.addView(topBar);
		
		// ========================================================
		// 3. جلب قائمة المفضلة وبناء الواجهة في الخلفية (لمنع التعليق)
		// ========================================================
		final String bList = bookmarksData.getString("list", "");
		
		if (bList.trim().isEmpty()) {
			    android.widget.LinearLayout emptyLayout = new android.widget.LinearLayout(this);
			    emptyLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
			    emptyLayout.setGravity(android.view.Gravity.CENTER);
			    emptyLayout.setPadding(40, 150, 40, 0);
			    
			    android.widget.TextView tvEmptyIcon = new android.widget.TextView(this);
			    tvEmptyIcon.setText("📿"); tvEmptyIcon.setTextSize(60); tvEmptyIcon.setGravity(android.view.Gravity.CENTER); tvEmptyIcon.setPadding(0,0,0,30);
			    
			    android.widget.TextView tvEmpty = new android.widget.TextView(this);
			    tvEmpty.setText("قائمتك فارغة!\nاضغط مطولاً على أي آية أثناء القراءة لإضافتها إلى مفضلتك.");
			    tvEmpty.setTextSize(16); tvEmpty.setTextColor(android.graphics.Color.GRAY); tvEmpty.setGravity(android.view.Gravity.CENTER); tvEmpty.setLineSpacing(0, 1.4f);
			    
			    emptyLayout.addView(tvEmptyIcon); emptyLayout.addView(tvEmpty);
			    mainLayout.addView(emptyLayout);
		} else {
			    // مؤشر تحميل ريثما يتم جلب البيانات
			    final android.widget.ProgressBar loader = new android.widget.ProgressBar(this);
			    mainLayout.addView(loader);
			
			    new Thread(new Runnable() {
				        @Override
				        public void run() {
					            try {
						                java.io.InputStream isIndex = getAssets().open("index.json");
						                java.util.Scanner scIndex = new java.util.Scanner(isIndex).useDelimiter("\\A");
						                final org.json.JSONArray indexArray = new org.json.JSONArray(scIndex.hasNext() ? scIndex.next() : "");
						                scIndex.close();
						                
						                java.io.InputStream isAyat = getAssets().open("ayat.json");
						                java.util.Scanner scAyat = new java.util.Scanner(isAyat).useDelimiter("\\A");
						                final org.json.JSONArray surahsArray = new org.json.JSONArray(scAyat.hasNext() ? scAyat.next() : "");
						                scAyat.close();
						
						                runOnUiThread(new Runnable() {
							                    @Override
							                    public void run() {
								                        mainLayout.removeView(loader); // إزالة مؤشر التحميل
								                        String[] items = bList.split(",");
								                        
								                        for (int i = items.length - 1; i >= 0; i--) { // عرض الأحدث أولاً
									                            if (items[i].trim().isEmpty()) continue;
									                            String[] parts = items[i].split(":");
									                            if (parts.length != 2) continue;
									
									                            final int sId = Integer.parseInt(parts[0]);
									                            final int aId = Integer.parseInt(parts[1]);
									                            final String itemKey = items[i] + ",";
									
									                            String surahName = ""; String ayahText = "";
									                            try {
										                                surahName = indexArray.getJSONObject(sId - 1).getString("name");
										                                org.json.JSONArray vs = surahsArray.getJSONObject(sId - 1).getJSONArray("verses");
										                                for (int j = 0; j < vs.length(); j++) {
											                                    if (vs.getJSONObject(j).getInt("number") == aId) {
												                                        ayahText = vs.getJSONObject(j).getJSONObject("text").getString("ar");
												                                        break;
												                                    }
											                                }
										                            } catch (Exception e) { continue; }
									
									                            final String finalSurahName = surahName;
									                            final String finalAyahText = ayahText;
									
									                            // -- بناء بطاقة الآية --
									                            final android.widget.LinearLayout card = new android.widget.LinearLayout(BookmarksActivity.this);
									                            card.setOrientation(android.widget.LinearLayout.VERTICAL); card.setPadding(40, 40, 40, 40); card.setElevation(15f);
									                            android.graphics.drawable.GradientDrawable cardBg = new android.graphics.drawable.GradientDrawable();
									                            cardBg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE);
									                            cardBg.setCornerRadius(30f); card.setBackground(cardBg);
									                            android.widget.LinearLayout.LayoutParams cardParams = new android.widget.LinearLayout.LayoutParams(-1, -2);
									                            cardParams.setMargins(0, 0, 0, 35); card.setLayoutParams(cardParams);
									
									                            // ترويسة البطاقة
									                            android.widget.LinearLayout headerRow = new android.widget.LinearLayout(BookmarksActivity.this);
									                            headerRow.setOrientation(android.widget.LinearLayout.HORIZONTAL); headerRow.setPadding(0, 0, 0, 20);
									                            
									                            android.widget.TextView tvHeader = new android.widget.TextView(BookmarksActivity.this);
									                            tvHeader.setText(finalSurahName + " - الآية " + aId);
									                            tvHeader.setTextColor(android.graphics.Color.parseColor("#388E3C")); tvHeader.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
									                            tvHeader.setTextSize(14); android.widget.LinearLayout.LayoutParams hParams = new android.widget.LinearLayout.LayoutParams(0, -2, 1f);
									                            tvHeader.setLayoutParams(hParams);
									                            
									                            // زر الحذف (أيقونة في أعلى اليسار)
									                            android.widget.TextView btnDel = new android.widget.TextView(BookmarksActivity.this);
									                            btnDel.setText("✖"); btnDel.setTextColor(android.graphics.Color.parseColor("#D32F2F"));
									                            btnDel.setTextSize(16); btnDel.setPadding(20, 0, 20, 0);
									                            
									                            headerRow.addView(tvHeader); headerRow.addView(btnDel);
									
									                            // نص الآية
									                            android.widget.TextView tvAyah = new android.widget.TextView(BookmarksActivity.this);
									                            tvAyah.setText(finalAyahText); tvAyah.setTextSize(22); tvAyah.setTypeface(quranFont);
									                            tvAyah.setTextColor(isDarkMode ? android.graphics.Color.parseColor("#E0E0E0") : android.graphics.Color.BLACK);
									                            tvAyah.setLineSpacing(0, 1.3f); tvAyah.setGravity(android.view.Gravity.RIGHT); tvAyah.setPadding(0, 10, 0, 30);
									
									                            // الإجراءات السريعة (شريط سفلي)
									                            android.widget.LinearLayout actionRow = new android.widget.LinearLayout(BookmarksActivity.this);
									                            actionRow.setOrientation(android.widget.LinearLayout.HORIZONTAL);
									                            actionRow.setGravity(android.view.Gravity.LEFT);
									                            
									                            android.widget.LinearLayout.LayoutParams btnParams = new android.widget.LinearLayout.LayoutParams(-2, -2);
									                            btnParams.setMargins(15, 0, 0, 0);
									
									                            // زر الذهاب للقراءة
									                            android.widget.TextView btnGo = new android.widget.TextView(BookmarksActivity.this);
									                            btnGo.setText("📖 قراءة"); btnGo.setTextColor(android.graphics.Color.WHITE); btnGo.setTextSize(12); btnGo.setPadding(40, 20, 40, 20);
									                            android.graphics.drawable.GradientDrawable goBg = new android.graphics.drawable.GradientDrawable(); goBg.setColor(android.graphics.Color.parseColor("#388E3C")); goBg.setCornerRadius(20f); btnGo.setBackground(goBg);
									                            btnGo.setLayoutParams(btnParams);
									
									                            // زر المشاركة
									                            android.widget.TextView btnShare = new android.widget.TextView(BookmarksActivity.this);
									                            btnShare.setText("📤 مشاركة"); btnShare.setTextColor(android.graphics.Color.parseColor("#1976D2")); btnShare.setTextSize(12); btnShare.setPadding(40, 20, 40, 20);
									                            android.graphics.drawable.GradientDrawable shareBg = new android.graphics.drawable.GradientDrawable(); shareBg.setColor(android.graphics.Color.TRANSPARENT); shareBg.setStroke((int)(1.5*dp), android.graphics.Color.parseColor("#1976D2")); shareBg.setCornerRadius(20f); btnShare.setBackground(shareBg);
									                            btnShare.setLayoutParams(btnParams);
									
									                            // زر النسخ
									                            android.widget.TextView btnCopy = new android.widget.TextView(BookmarksActivity.this);
									                            btnCopy.setText("📋 نسخ"); btnCopy.setTextColor(android.graphics.Color.GRAY); btnCopy.setTextSize(12); btnCopy.setPadding(40, 20, 40, 20);
									                            android.graphics.drawable.GradientDrawable copyBg = new android.graphics.drawable.GradientDrawable(); copyBg.setColor(android.graphics.Color.TRANSPARENT); copyBg.setStroke((int)(1.5*dp), android.graphics.Color.GRAY); copyBg.setCornerRadius(20f); btnCopy.setBackground(copyBg);
									                            btnCopy.setLayoutParams(btnParams);
									
									                            actionRow.addView(btnGo); actionRow.addView(btnShare); actionRow.addView(btnCopy);
									
									                            card.addView(headerRow); card.addView(tvAyah); card.addView(actionRow);
									                            mainLayout.addView(card);
									
									                            // ---------------- الأوامر البرمجية ----------------
									                            
									                            // 1. القراءة
									                            btnGo.setOnClickListener(new android.view.View.OnClickListener() {
										                                @Override public void onClick(android.view.View v) {
											                                    android.content.Intent intent = new android.content.Intent(BookmarksActivity.this, ReadingActivity.class);
											                                    intent.putExtra("surah_id", String.valueOf(sId));
											                                    intent.putExtra("ayah_id", String.valueOf(aId));
											                                    startActivity(intent);
											                                }
										                            });
									
									                            // 2. المشاركة
									                            btnShare.setOnClickListener(new android.view.View.OnClickListener() {
										                                @Override public void onClick(android.view.View v) {
											                                    android.content.Intent shareIntent = new android.content.Intent(android.content.Intent.ACTION_SEND);
											                                    shareIntent.setType("text/plain");
											                                    shareIntent.putExtra(android.content.Intent.EXTRA_TEXT, finalAyahText + " ﴿" + finalSurahName + ": " + aId + "﴾");
											                                    startActivity(android.content.Intent.createChooser(shareIntent, "مشاركة الآية"));
											                                }
										                            });
									
									                            // 3. النسخ
									                            btnCopy.setOnClickListener(new android.view.View.OnClickListener() {
										                                @Override public void onClick(android.view.View v) {
											                                    android.content.ClipboardManager clipboard = (android.content.ClipboardManager) getSystemService(android.content.Context.CLIPBOARD_SERVICE);
											                                    android.content.ClipData clip = android.content.ClipData.newPlainText("Ayah", finalAyahText + " ﴿" + finalSurahName + ": " + aId + "﴾");
											                                    clipboard.setPrimaryClip(clip);
											                                    android.widget.Toast.makeText(BookmarksActivity.this, "تم نسخ الآية للحافظة", android.widget.Toast.LENGTH_SHORT).show();
											                                }
										                            });
									
									                            // 4. الحذف السلس (أنيميشن التلاشي)
									                            btnDel.setOnClickListener(new android.view.View.OnClickListener() {
										                                @Override public void onClick(android.view.View v) {
											                                    String currentList = bookmarksData.getString("list", "");
											                                    String newList = currentList.replace(itemKey, "");
											                                    bookmarksData.edit().putString("list", newList).apply();
											                                    
											                                    // حركة انسيابية لاختفاء البطاقة بدلاً من recreate المزعج
											                                    card.animate().alpha(0f).translationX(-100f).setDuration(300).withEndAction(new Runnable() {
												                                        @Override public void run() { 
													                                            mainLayout.removeView(card); 
													                                            // إذا أصبحت القائمة فارغة بعد الحذف، نعيد بناء الصفحة لتظهر شاشة "القائمة فارغة"
													                                            if(bookmarksData.getString("list", "").trim().isEmpty()) { recreate(); }
													                                        }
												                                    }).start();
											                                }
										                            });
									                        }
								                    }
							                });
						            } catch (Exception e) {}
					        }
				    }).start();
		}
		
		setContentView(scroll);
		
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