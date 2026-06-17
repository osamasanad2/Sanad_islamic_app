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

public class ReadingActivity extends AppCompatActivity {
	
	private String audioPlayerParams = "";
	
	@Override
	protected void onCreate(Bundle _savedInstanceState) {
		super.onCreate(_savedInstanceState);
		setContentView(R.layout.reading);
		initialize(_savedInstanceState);
		initializeLogic();
	}
	
	private void initialize(Bundle _savedInstanceState) {
	}
	
	private void initializeLogic() {
		_moorblok();
	}
	
	@Override
	public void onPause() {
		super.onPause();
		
	}
	public void _setHighlighter(final TextView _view) {
		// ================== 1. تعريف الألوان ==================
		final int COLOR_RED = android.graphics.Color.parseColor("#E53935");
		final int COLOR_BLUE = android.graphics.Color.parseColor("#1E88E5");
		final int COLOR_GREEN = android.graphics.Color.parseColor("#43A047");
		final int COLOR_GOLD = android.graphics.Color.parseColor("#FDD835");
		final int COLOR_PURPLE = android.graphics.Color.parseColor("#8E24AA");
		
		final int COLOR_DIVINE = android.graphics.Color.parseColor("#8B0000");
		final int COLOR_HONOR = android.graphics.Color.parseColor("#00008B");
		final int COLOR_NUMBERS = android.graphics.Color.parseColor("#009688");
		
		final int BG_BRIGHT_YELLOW = android.graphics.Color.parseColor("#FFFF00");
		final int BG_CYAN = android.graphics.Color.parseColor("#80DEEA");
		final int BG_LIME = android.graphics.Color.parseColor("#CCFF90");
		final int BG_PINK = android.graphics.Color.parseColor("#F48FB1");
		
		// ================== 2. قوائم الكلمات ==================
		final String divineWords =
		        "الله|اللَّهِ|رب|الرحمن|الرحيم|تعالى|سبحانه|الخالق|القدوس|السلام|المؤمن|المهيمن|العزيز|الجبار|المتكبر|الغفار|القهار|الوهاب|الرزاق";
		
		final String honorWords =
		        "محمد|أحمد|عيسى|موسى|إبراهيم|نوح|يوسف|يونس|داود|سليمان|آدم|إسماعيل|إسحاق|يعقوب|شعيب|صالح|هود|لوط|زكريا|يحيى|أيوب|إلياس|اليسع|ذو الكفل|هارون|إدريس|" +
		        "رسول|الرسول|النبي|صلى|وسلم|عليه|رضي|عنه|أبي|بكر|عمر|عثمان|علي|عائشة|فاطمة|خديجة|الصحابة|المؤمنين|المسلمين|الجنة|النار|القرآن|سورة|البقرة|آل عمران|النساء|المائدة|الأنعام|الأعراف|الأنفال|التوبة|الكهف|يس|الواقعة|الناس|الفلق|الإخلاص";
		
		// ================== 3. قواعد الرموز ==================
		final Object[][] RULES = {
			        {"\"", "\"", COLOR_RED, false},
			        {"(", ")", COLOR_BLUE, false},
			        {"{", "}", COLOR_GREEN, false},
			        {"[", "]", COLOR_PURPLE, false},
			        {"<", ">", COLOR_GOLD, false},
			        {"/", "/", BG_BRIGHT_YELLOW, true},
			        {"*", "*", BG_CYAN, true},
			        {"|", "|", BG_LIME, true},
			        {"~", "~", BG_PINK, true}
		};
		
		// ================== 4. مراقب النص ==================
		_view.addTextChangedListener(new android.text.TextWatcher() {
			    public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
			    public void onTextChanged(CharSequence s, int start, int before, int count) {}
			
			    public void afterTextChanged(android.text.Editable s) {
				
				        Object[] spans = s.getSpans(0, s.length(), Object.class);
				        for (Object span : spans) {
					            if (span instanceof android.text.style.ForegroundColorSpan ||
					                span instanceof android.text.style.BackgroundColorSpan ||
					                span instanceof android.text.style.ScaleXSpan) {
						                s.removeSpan(span);
						            }
					        }
				
				        String text = s.toString();
				
				        // الأرقام
				        java.util.regex.Matcher numM =
				                java.util.regex.Pattern.compile("[0-9٠-٩]+").matcher(text);
				        while (numM.find()) {
					            s.setSpan(new android.text.style.ForegroundColorSpan(COLOR_NUMBERS),
					                    numM.start(), numM.end(), 33);
					        }
				
				        // ألفاظ جلالة
				        java.util.regex.Matcher divM =
				                java.util.regex.Pattern.compile(divineWords).matcher(text);
				        while (divM.find()) {
					            s.setSpan(new android.text.style.ForegroundColorSpan(COLOR_DIVINE),
					                    divM.start(), divM.end(), 33);
					        }
				
				        // الأنبياء والسور
				        java.util.regex.Matcher honM =
				                java.util.regex.Pattern.compile(honorWords).matcher(text);
				        while (honM.find()) {
					            s.setSpan(new android.text.style.ForegroundColorSpan(COLOR_HONOR),
					                    honM.start(), honM.end(), 33);
					        }
				
				        // الرموز
				        for (Object[] rule : RULES) {
					            String startSym = (String) rule[0];
					            String endSym   = (String) rule[1];
					            int color       = (Integer) rule[2];
					            boolean isBg    = (Boolean) rule[3];
					
					            String p = java.util.regex.Pattern.quote(startSym)
					                    + "(.*?)"
					                    + java.util.regex.Pattern.quote(endSym);
					
					            java.util.regex.Matcher m =
					                    java.util.regex.Pattern.compile(p).matcher(text);
					
					            while (m.find()) {
						
						                boolean hideSymbol = true;
						
						                if ("/".equals(startSym)) {
							                    int a = m.start();
							                    int b = m.end() - 1;
							
							                    boolean leftDigit  = a > 0 && Character.isDigit(text.charAt(a - 1));
							                    boolean rightDigit = b + 1 < text.length() && Character.isDigit(text.charAt(b + 1));
							
							                    hideSymbol = !(leftDigit && rightDigit);
							                }
						
						                if (hideSymbol) {
							                    s.setSpan(new android.text.style.ForegroundColorSpan(android.graphics.Color.TRANSPARENT),
							                            m.start(), m.start() + 1, 33);
							                    s.setSpan(new android.text.style.ScaleXSpan(0.1f),
							                            m.start(), m.start() + 1, 33);
							
							                    s.setSpan(new android.text.style.ForegroundColorSpan(android.graphics.Color.TRANSPARENT),
							                            m.end() - 1, m.end(), 33);
							                    s.setSpan(new android.text.style.ScaleXSpan(0.1f),
							                            m.end() - 1, m.end(), 33);
							                }
						
						                if (isBg) {
							                    s.setSpan(new android.text.style.BackgroundColorSpan(color),
							                            m.start() + 1, m.end() - 1, 33);
							                } else {
							                    s.setSpan(new android.text.style.ForegroundColorSpan(color),
							                            m.start() + 1, m.end() - 1, 33);
							                }
						            }
					        }
				    }
		});
		
		// ================== 5. قائمة التنسيق ==================
		_view.setCustomSelectionActionModeCallback(new android.view.ActionMode.Callback() {
			
			    public boolean onCreateActionMode(android.view.ActionMode mode, android.view.Menu menu) {
				        menu.add(0, 1, 0, "🎨 تنسيق").setShowAsAction(2);
				        return true;
				    }
			
			    public boolean onPrepareActionMode(android.view.ActionMode mode, android.view.Menu menu) {
				        return false;
				    }
			
			    public boolean onActionItemClicked(final android.view.ActionMode mode,
			                                       android.view.MenuItem item) {
				
				        if (item.getItemId() == 1) {
					
					            final String[] opts = {
						                    "أحمر","أزرق","أخضر","بنفسجي","ذهبي",
						                    "أصفر مشرق","سماوي","ليموني","وردي","❌ مسح التنسيق"
						            };
					
					            new android.app.AlertDialog.Builder(_view.getContext())
					                    .setTitle("اختر اللون")
					                    .setItems(opts, new android.content.DialogInterface.OnClickListener() {
						                        @Override
						                        public void onClick(android.content.DialogInterface d, int which) {
							
							                            int start = _view.getSelectionStart();
							                            int end   = _view.getSelectionEnd();
							                            if (start == end) return;
							
							                            android.text.Editable e =
							                                    (android.text.Editable) _view.getText();
							
							                            String clean =
							                                    e.subSequence(start, end).toString()
							                                            .replaceAll("[\"(){}\\[\\]<>\\*\\|~]", "");
							
							                            if (which < 9) {
								                                e.replace(start, end,
								                                        (String) RULES[which][0] + clean + (String) RULES[which][1]);
								                            } else {
								                                e.replace(start, end, clean);
								                            }
							
							                            mode.finish();
							                        }
						                    }).show();
					
					            return true;
					        }
				        return false;
				    }
			
			    public void onDestroyActionMode(android.view.ActionMode mode) {}
		});
	}
	
	
	public void _moorblok() {
		// 1. الإعدادات والمتغيرات الأساسية
		final android.content.SharedPreferences prefs = getSharedPreferences("QuranPrefs", android.content.Context.MODE_PRIVATE);
		final android.content.SharedPreferences memoData = getSharedPreferences("memo_data", android.content.Context.MODE_PRIVATE);
		final android.content.SharedPreferences bookmarksData = getSharedPreferences("bookmarks_data", android.content.Context.MODE_PRIVATE);
		
		final float[] currentFontSize = {prefs.getFloat("font_size", 28f)};
		final boolean[] currentIsDarkMode = {prefs.getBoolean("dark_mode", false)};
		final String[] currentFontPath = {prefs.getString("font_path", "fonts/add.ttf")};
		final boolean[] useEnglishNumbers = {prefs.getBoolean("eng_nums", false)};
		final int[] numberShapeStyle = {prefs.getInt("num_shape", 0)};
		final boolean[] autoPlayOnLongPress = {prefs.getBoolean("auto_play_long", false)};
		final int[] customBgColor = {prefs.getInt("custom_bg", android.graphics.Color.parseColor("#FDF6E3"))};
		final boolean[] useEnglishLanguage = {prefs.getBoolean("use_english", false)};
		final int[] seekbarDisplayMode = {prefs.getInt("seekbar_display_mode", 0)};
		final boolean[] showOnlyCurrentAyah = {false};
		
		final int[] searchedSurah = {-1};
		final int[] searchedAyah = {-1};
		if (getIntent().hasExtra("ayah_id") && getIntent().hasExtra("surah_id")) {
			    try {
				        searchedSurah[0] = Integer.parseInt(getIntent().getStringExtra("surah_id"));
				        searchedAyah[0] = Integer.parseInt(getIntent().getStringExtra("ayah_id"));
				    } catch (Exception e) {}
		}
		
		final android.graphics.Typeface[] quranFont = {null};
		try { quranFont[0] = android.graphics.Typeface.createFromAsset(getAssets(), currentFontPath[0]); } catch(Exception e) { quranFont[0] = android.graphics.Typeface.DEFAULT; }
		final android.graphics.Typeface surahNumFont = android.graphics.Typeface.DEFAULT_BOLD;
		
		final boolean[] isTestMode = {false};
		final boolean[] playSingleAyahOnly = {false};
		final int[] currentAudioSurah = {0};
		final int[] currentAudioAyah = {0};
		final int[] currentRepeatMode = {0};
		final int[] currentRepeatCount = {0};
		final android.media.MediaPlayer[] quranPlayer = {null};
		final java.util.HashMap<Integer, Integer> testRevealedUpToAyah = new java.util.HashMap<>();
		final java.util.HashMap<String, String> enTranslations = new java.util.HashMap<>();
		final int[] totalAyahsPerSurah = new int[115];
		
		class AyahRef { int s, a; public AyahRef(int s, int a) { this.s = s; this.a = a; } }
		final java.util.ArrayList<AyahRef> allAyahsList = new java.util.ArrayList<>();
		
		final boolean[] isAutoScrolling = {false};
		final int[] scrollSpeedDelay = {30};
		final int[] currentAutoScrollStartPage = {0};
		final android.os.Handler scrollHandler = new android.os.Handler();
		final int[] lastLoadedAutoScrollPage = {0};
		
		final android.widget.SeekBar audioSeekBar = new android.widget.SeekBar(this);
		final android.os.Handler audioProgressHandler = new android.os.Handler();
		final Runnable[] audioProgressRunnable = {null};
		
		final android.widget.RelativeLayout rootFrame = new android.widget.RelativeLayout(this);
		rootFrame.setBackgroundColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#121212") : customBgColor[0]);
		getWindow().addFlags(android.view.WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		
		if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
			    getWindow().setDecorFitsSystemWindows(false);
			    getWindow().setStatusBarColor(android.graphics.Color.TRANSPARENT);
			    getWindow().setNavigationBarColor(android.graphics.Color.TRANSPARENT);
		} else {
			    getWindow().getDecorView().setSystemUiVisibility(
			        android.view.View.SYSTEM_UI_FLAG_LAYOUT_STABLE |
			        android.view.View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN |
			        android.view.View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
			    );
		}
		
		final java.util.LinkedHashMap<Integer, String> pageTextsMap = new java.util.LinkedHashMap<>();
		final java.util.LinkedHashMap<Integer, String> pageSurahMap = new java.util.LinkedHashMap<>();
		final java.util.LinkedHashMap<Integer, String> pageJuzMap = new java.util.LinkedHashMap<>();
		final java.util.List<Integer> sortedPages = new java.util.ArrayList<>();
		final java.util.List<Integer> surahStartPages = new java.util.ArrayList<>();
		final java.util.List<String> surahNamesList = new java.util.ArrayList<>();
		final java.util.List<String> surahTypesList = new java.util.ArrayList<>();
		final java.util.HashMap<String, Integer> ayahPageMap = new java.util.HashMap<>();
		
		try {
			    java.io.InputStream is = getAssets().open("ayat.json");
			    java.util.Scanner sc = new java.util.Scanner(is).useDelimiter("\\A");
			    org.json.JSONArray surahsArray = new org.json.JSONArray(sc.hasNext() ? sc.next() : "");
			    sc.close();
			
			    surahStartPages.clear(); surahTypesList.clear(); allAyahsList.clear();
			    for (int i = 0; i < surahsArray.length(); i++) {
				        org.json.JSONObject surahObj = surahsArray.getJSONObject(i);
				        String sNum = String.valueOf(i + 1);
				        String sName = (surahObj.has("name") && surahObj.getJSONObject("name").has("ar")) ? surahObj.getJSONObject("name").getString("ar") : "سورة " + sNum;
				        surahNamesList.add(sName);
				
				        String sType = surahObj.has("type") ? surahObj.getString("type") : (surahObj.has("revelationType") ? surahObj.getString("revelationType") : "meccan");
				        java.util.List<Integer> medinanList = java.util.Arrays.asList(2, 3, 4, 5, 8, 9, 13, 22, 24, 33, 47, 48, 49, 55, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 76, 98, 110);
				        if (medinanList.contains(i + 1)) sType = "medinan";
				        surahTypesList.add(sType.toLowerCase());
				
				        org.json.JSONArray vs = surahObj.getJSONArray("verses");
				        totalAyahsPerSurah[i + 1] = vs.length();
				        int firstPageOfSurah = vs.getJSONObject(0).has("page") ? vs.getJSONObject(0).getInt("page") : 1;
				        surahStartPages.add(firstPageOfSurah);
				
				        for (int j = 0; j < vs.length(); j++) {
					            org.json.JSONObject verseObj = vs.getJSONObject(j);
					            org.json.JSONObject textObj = verseObj.getJSONObject("text");
					            String vText = textObj.getString("ar");
					            String enText = textObj.has("en") ? textObj.getString("en") : "";
					            int vNum = verseObj.getInt("number");
					
					            allAyahsList.add(new AyahRef(i + 1, vNum));
					            enTranslations.put(sNum + ":" + vNum, enText);
					            int pageNum = verseObj.has("page") ? verseObj.getInt("page") : 1;
					            int juzNum = verseObj.has("juz") ? verseObj.getInt("juz") : 1;
					            ayahPageMap.put(sNum + ":" + vNum, pageNum);
					
					            if (!pageTextsMap.containsKey(pageNum)) {
						                pageTextsMap.put(pageNum, ""); sortedPages.add(pageNum);
						                pageSurahMap.put(pageNum, sName); pageJuzMap.put(pageNum, "الجزء " + juzNum);
						            }
					
					            if (vNum == 1) {
						                String header = "[SH]" + sName + "[SH]";
						                pageTextsMap.put(pageNum, pageTextsMap.get(pageNum) + header);
						                if (i != 8) pageTextsMap.put(pageNum, pageTextsMap.get(pageNum) + "\nبِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ\n");
						            }
					
					            String currentText = pageTextsMap.get(pageNum);
					            pageTextsMap.put(pageNum, currentText + vText + " [#]" + vNum + "[@] " + sNum + ":" + vNum + " [@] ");
					        }
				    }
		} catch (Exception e) { android.util.Log.e("Quran", "Error parsing json", e); }
		
		final androidx.viewpager.widget.ViewPager vp = new androidx.viewpager.widget.ViewPager(this);
		vp.setId(android.view.View.generateViewId());
		rootFrame.addView(vp, new android.widget.RelativeLayout.LayoutParams(-1, -1));
		
		final android.widget.ScrollView verticalAutoScroll = new android.widget.ScrollView(this);
		verticalAutoScroll.setVisibility(android.view.View.GONE);
		verticalAutoScroll.setVerticalScrollBarEnabled(false);
		final android.widget.LinearLayout verticalPagesContainer = new android.widget.LinearLayout(this);
		verticalPagesContainer.setOrientation(android.widget.LinearLayout.VERTICAL);
		verticalPagesContainer.setPadding(30, 40, 30, 200);
		verticalAutoScroll.addView(verticalPagesContainer, new android.widget.ScrollView.LayoutParams(-1, -2));
		rootFrame.addView(verticalAutoScroll, new android.widget.RelativeLayout.LayoutParams(-1, -1));
		
		final float density = getResources().getDisplayMetrics().density;
		final boolean hasKhatma = prefs.getBoolean("has_khatma", false);
		final boolean isKhatmaEntry = getIntent().getBooleanExtra("continue_khatma", false);
		
		final int[] planSurah = {-1};
		final int[] planStartAyah = {-1};
		final int[] planEndAyah = {-1};
		if (getIntent().hasExtra("target_start_ayah") && getIntent().hasExtra("target_end_ayah") && getIntent().hasExtra("surah_id")) {
			    planSurah[0] = Integer.parseInt(getIntent().getStringExtra("surah_id"));
			    planStartAyah[0] = getIntent().getIntExtra("target_start_ayah", 1);
			    planEndAyah[0] = getIntent().getIntExtra("target_end_ayah", 1);
		}
		
		if (hasKhatma) {
			    final String kName = prefs.getString("khatma_name", "متابعة الختمة");
			    final int kDays = prefs.getInt("khatma_days", 30);
			    final int totalAyahs = allAyahsList.size();
			    final int ayahsPerDay = totalAyahs / (kDays > 0 ? kDays : 1);
			
			    final android.widget.RelativeLayout popupContainer = new android.widget.RelativeLayout(this);
			    android.widget.RelativeLayout.LayoutParams contParams = new android.widget.RelativeLayout.LayoutParams(-1, -2);
			    contParams.setMargins((int)(20*density), (int)(80*density), (int)(20*density), 0);
			    popupContainer.setLayoutParams(contParams); popupContainer.setVisibility(android.view.View.GONE);
			
			    final android.widget.LinearLayout popupCard = new android.widget.LinearLayout(this);
			    popupCard.setOrientation(android.widget.LinearLayout.VERTICAL); popupCard.setPadding((int)(15*density), (int)(15*density), (int)(15*density), (int)(15*density));
			    android.graphics.drawable.GradientDrawable popBg = new android.graphics.drawable.GradientDrawable();
			    popBg.setColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.parseColor("#F1EBD9"));
			    popBg.setCornerRadius(40f); popBg.setStroke(3, android.graphics.Color.parseColor("#A3B899"));
			    popupCard.setBackground(popBg); popupCard.setElevation(15f);
			    popupCard.setLayoutParams(new android.widget.RelativeLayout.LayoutParams(-1, -2));
			
			    final android.widget.TextView tvKhatmaNameTitle = new android.widget.TextView(this);
			    tvKhatmaNameTitle.setText("الورد الحالي: " + kName); tvKhatmaNameTitle.setTextSize(16);
			    tvKhatmaNameTitle.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.parseColor("#385E43"));
			    tvKhatmaNameTitle.setTypeface(android.graphics.Typeface.DEFAULT_BOLD); tvKhatmaNameTitle.setGravity(android.view.Gravity.CENTER);
			    tvKhatmaNameTitle.setPadding(0, 0, 0, (int)(15*density));
			    popupCard.addView(tvKhatmaNameTitle);
			
			    android.widget.RelativeLayout progressSection = new android.widget.RelativeLayout(this);
			    progressSection.setPadding(0, 0, 0, (int)(15*density));
			
			    final android.widget.LinearLayout boxSaved = new android.widget.LinearLayout(this);
			    boxSaved.setOrientation(android.widget.LinearLayout.HORIZONTAL); boxSaved.setGravity(android.view.Gravity.CENTER);
			    boxSaved.setPadding((int)(10*density), (int)(5*density), (int)(10*density), (int)(5*density));
			    android.graphics.drawable.GradientDrawable boxSavedBg = new android.graphics.drawable.GradientDrawable();
			    boxSavedBg.setColor(android.graphics.Color.parseColor("#66BB6A")); boxSavedBg.setCornerRadius(20f);
			    boxSaved.setBackground(boxSavedBg); boxSaved.setId(android.view.View.generateViewId());
			
			    final android.widget.TextView tvSavedIcon = new android.widget.TextView(this); tvSavedIcon.setText("📌 "); tvSavedIcon.setTextColor(android.graphics.Color.WHITE);
			    final android.widget.TextView tvSavedText = new android.widget.TextView(this); tvSavedText.setText("الموضع المحفوظ"); tvSavedText.setTextColor(android.graphics.Color.WHITE); tvSavedText.setTextSize(12);
			    boxSaved.addView(tvSavedIcon); boxSaved.addView(tvSavedText);
			
			    final android.view.View barBgView = new android.view.View(this); barBgView.setId(android.view.View.generateViewId());
			    android.graphics.drawable.GradientDrawable pBarBg = new android.graphics.drawable.GradientDrawable(); pBarBg.setColor(android.graphics.Color.WHITE); pBarBg.setCornerRadius(20f);
			    barBgView.setBackground(pBarBg);
			
			    final android.view.View barFillView = new android.view.View(this);
			    android.graphics.drawable.GradientDrawable pBarFill = new android.graphics.drawable.GradientDrawable(); pBarFill.setColor(android.graphics.Color.parseColor("#4CAF50")); pBarFill.setCornerRadius(20f);
			    barFillView.setBackground(pBarFill);
			
			    final android.widget.TextView boxEnd = new android.widget.TextView(this);
			    boxEnd.setText("سورة : 00"); boxEnd.setTextSize(12); boxEnd.setTextColor(android.graphics.Color.parseColor("#385E43"));
			    boxEnd.setPadding((int)(15*density), (int)(8*density), (int)(15*density), (int)(8*density));
			    android.graphics.drawable.GradientDrawable boxEndBg = new android.graphics.drawable.GradientDrawable(); boxEndBg.setColor(android.graphics.Color.WHITE); boxEndBg.setCornerRadius(20f);
			    boxEnd.setBackground(boxEndBg); boxEnd.setId(android.view.View.generateViewId());
			
			    final android.widget.TextView boxStart = new android.widget.TextView(this);
			    boxStart.setText("سورة : 00"); boxStart.setTextSize(12); boxStart.setTextColor(android.graphics.Color.parseColor("#385E43"));
			    boxStart.setPadding((int)(15*density), (int)(8*density), (int)(15*density), (int)(8*density));
			    boxStart.setBackground(boxEndBg); boxStart.setId(android.view.View.generateViewId());
			
			    android.widget.RelativeLayout.LayoutParams pBar = new android.widget.RelativeLayout.LayoutParams(-1, (int)(15*density));
			    pBar.addRule(android.widget.RelativeLayout.BELOW, boxSaved.getId()); pBar.setMargins(0, (int)(10*density), 0, (int)(10*density));
			    barBgView.setLayoutParams(pBar);
			
			    android.widget.RelativeLayout.LayoutParams pBarF = new android.widget.RelativeLayout.LayoutParams(0, (int)(15*density));
			    pBarF.addRule(android.widget.RelativeLayout.ALIGN_TOP, barBgView.getId()); pBarF.addRule(android.widget.RelativeLayout.ALIGN_LEFT, barBgView.getId());
			    barFillView.setLayoutParams(pBarF);
			
			    android.widget.RelativeLayout.LayoutParams pEnd = new android.widget.RelativeLayout.LayoutParams(-2, -2);
			    pEnd.addRule(android.widget.RelativeLayout.BELOW, barBgView.getId()); pEnd.addRule(android.widget.RelativeLayout.ALIGN_PARENT_LEFT);
			    boxEnd.setLayoutParams(pEnd);
			
			    android.widget.RelativeLayout.LayoutParams pStart = new android.widget.RelativeLayout.LayoutParams(-2, -2);
			    pStart.addRule(android.widget.RelativeLayout.BELOW, barBgView.getId()); pStart.addRule(android.widget.RelativeLayout.ALIGN_PARENT_RIGHT);
			    boxStart.setLayoutParams(pStart);
			
			    progressSection.addView(boxSaved); progressSection.addView(barBgView); progressSection.addView(barFillView); progressSection.addView(boxEnd); progressSection.addView(boxStart);
			    popupCard.addView(progressSection);
			
			    final android.widget.Button btnCompleteWird = new android.widget.Button(this);
			    btnCompleteWird.setText("أتممت الورد ✔️"); btnCompleteWird.setTextColor(android.graphics.Color.WHITE);
			    android.graphics.drawable.GradientDrawable btnCbg = new android.graphics.drawable.GradientDrawable(); btnCbg.setColor(android.graphics.Color.parseColor("#5DB061")); btnCbg.setCornerRadius(25f);
			    btnCompleteWird.setBackground(btnCbg); popupCard.addView(btnCompleteWird, new android.widget.LinearLayout.LayoutParams(-1, -2));
			
			    popupContainer.addView(popupCard); rootFrame.addView(popupContainer);
			
			    final android.widget.Button btnKhatmaMode = new android.widget.Button(this);
			    btnKhatmaMode.setText("📖"); btnKhatmaMode.setTextColor(android.graphics.Color.parseColor("#F5F0DC")); btnKhatmaMode.setTextSize(18);
			    android.graphics.drawable.GradientDrawable btnModeBg = new android.graphics.drawable.GradientDrawable(); btnModeBg.setColor(android.graphics.Color.parseColor("#385E43")); btnModeBg.setCornerRadius(100f);
			    btnKhatmaMode.setBackground(btnModeBg);
			    android.widget.RelativeLayout.LayoutParams btnMParams = new android.widget.RelativeLayout.LayoutParams((int)(50*density), (int)(50*density));
			    btnMParams.setMargins(0, (int)(15*density), (int)(15*density), 0); btnMParams.addRule(android.widget.RelativeLayout.ALIGN_PARENT_RIGHT); btnMParams.addRule(android.widget.RelativeLayout.ALIGN_PARENT_TOP);
			    btnKhatmaMode.setLayoutParams(btnMParams); rootFrame.addView(btnKhatmaMode);
			
			    if (!isKhatmaEntry) { btnKhatmaMode.setVisibility(android.view.View.GONE); }
			
			    final Runnable updatePopupData = new Runnable() {
				        @Override public void run() {
					            int compSessions = prefs.getInt("khatma_sessions_completed", 0);
					            int startIndex = compSessions * ayahsPerDay;
					            int endIndex = Math.min(startIndex + ayahsPerDay - 1, totalAyahs - 1);
					            if(startIndex >= totalAyahs) { tvKhatmaNameTitle.setText("لقد ختمت القرآن، تقبل الله منك!"); return; }
					
					            final AyahRef startRef = allAyahsList.get(startIndex);
					            final AyahRef endRef = allAyahsList.get(endIndex);
					
					            boxStart.setText(surahNamesList.get(startRef.s - 1) + " : " + startRef.a);
					            boxEnd.setText(surahNamesList.get(endRef.s - 1) + " : " + endRef.a);
					
					            final int savedS = prefs.getInt("saved_sura", -1); final int savedA = prefs.getInt("saved_ayah", -1);
					            int readInWird = 0;
					
					            if(savedS != -1 && savedA != -1) {
						                boxSaved.setVisibility(android.view.View.VISIBLE);
						                tvSavedText.setText(surahNamesList.get(savedS - 1) + " : " + savedA);
						
						                int savedAbsoluteIndex = -1;
						                for(int i = startIndex; i <= endIndex; i++) {
							                    if(allAyahsList.get(i).s == savedS && allAyahsList.get(i).a == savedA) {
								                        savedAbsoluteIndex = i; break;
								                    }
							                }
						                if(savedAbsoluteIndex != -1) { readInWird = savedAbsoluteIndex - startIndex + 1; }
						            } else { boxSaved.setVisibility(android.view.View.INVISIBLE); }
					
					            int wirdTotalAyahs = endIndex - startIndex + 1;
					            final int percent = (int)(((float)readInWird / wirdTotalAyahs) * 100);
					
					            barBgView.post(new Runnable() {
						                @Override public void run() {
							                    int w = (int) (barBgView.getWidth() * (Math.min(percent, 100) / 100f));
							                    android.widget.RelativeLayout.LayoutParams p = (android.widget.RelativeLayout.LayoutParams) barFillView.getLayoutParams();
							                    p.width = w; barFillView.setLayoutParams(p);
							
							                    if(savedS != -1) {
								                        android.widget.RelativeLayout.LayoutParams sParams = new android.widget.RelativeLayout.LayoutParams(-2, -2);
								                        sParams.setMargins(w - (boxSaved.getWidth() / 2), 0, 0, 0);
								                        boxSaved.setLayoutParams(sParams);
								                    }
							                }
						            });
					
					            boxStart.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { int pNum = ayahPageMap.get(startRef.s + ":" + startRef.a); int vIdx = sortedPages.indexOf(pNum); if(vIdx != -1) { vp.setCurrentItem(vIdx, true); popupContainer.setVisibility(android.view.View.GONE); } } });
					            boxEnd.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { int pNum = ayahPageMap.get(endRef.s + ":" + endRef.a); int vIdx = sortedPages.indexOf(pNum); if(vIdx != -1) { vp.setCurrentItem(vIdx, true); popupContainer.setVisibility(android.view.View.GONE); } } });
					            boxSaved.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { if(savedS != -1) { int pNum = ayahPageMap.get(savedS + ":" + savedA); int vIdx = sortedPages.indexOf(pNum); if(vIdx != -1) { vp.setCurrentItem(vIdx, true); popupContainer.setVisibility(android.view.View.GONE); } } } });
					        }
				    };
			
			    btnKhatmaMode.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { if(popupContainer.getVisibility() == android.view.View.VISIBLE) popupContainer.setVisibility(android.view.View.GONE); else { popupContainer.setVisibility(android.view.View.VISIBLE); updatePopupData.run(); } } });
			    btnCompleteWird.setOnClickListener(new android.view.View.OnClickListener() { @Override public void onClick(android.view.View v) { int compSessions = prefs.getInt("khatma_sessions_completed", 0); prefs.edit().putInt("khatma_sessions_completed", compSessions + 1).apply(); android.widget.Toast.makeText(ReadingActivity.this, "تقبل الله! تم إتمام الورد.", android.widget.Toast.LENGTH_SHORT).show(); updatePopupData.run(); popupContainer.setVisibility(android.view.View.GONE); vp.getAdapter().notifyDataSetChanged(); } });
		}
		
		int barColor = android.graphics.Color.parseColor("#E61A1A1A");
		android.graphics.drawable.GradientDrawable barsBg = new android.graphics.drawable.GradientDrawable();
		barsBg.setColor(barColor); barsBg.setCornerRadius(40f);
		
		final android.widget.LinearLayout topBar = new android.widget.LinearLayout(this);
		topBar.setOrientation(android.widget.LinearLayout.HORIZONTAL); topBar.setBackground(barsBg); topBar.setPadding(20, 20, 20, 20); topBar.setGravity(android.view.Gravity.CENTER_VERTICAL); topBar.setVisibility(android.view.View.GONE); topBar.setClickable(true);
		
		android.widget.LinearLayout.LayoutParams iconParams = new android.widget.LinearLayout.LayoutParams(80, 80); iconParams.setMargins(20, 0, 20, 0);
		final android.widget.ImageView btnSettings = new android.widget.ImageView(this); btnSettings.setImageResource(R.drawable.ic_settings);
		final android.widget.ImageView btnSearch = new android.widget.ImageView(this); btnSearch.setImageResource(R.drawable.ic_search);
		final android.widget.ImageView btnTheme = new android.widget.ImageView(this); try { btnTheme.setImageResource(currentIsDarkMode[0] ? R.drawable.ic_moon : R.drawable.ic_sun); } catch(Exception e){}
		final android.widget.ImageView btnBookmarks = new android.widget.ImageView(this); btnBookmarks.setImageResource(R.drawable.ic_bookmark);
		
		android.view.View spacerTop = new android.view.View(this); spacerTop.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, 0, 1f));
		topBar.addView(btnSettings, iconParams); topBar.addView(btnSearch, iconParams); topBar.addView(spacerTop); topBar.addView(btnTheme, iconParams); topBar.addView(btnBookmarks, iconParams);
		android.widget.RelativeLayout.LayoutParams topBarParams = new android.widget.RelativeLayout.LayoutParams(-1, -2); topBarParams.addRule(android.widget.RelativeLayout.ALIGN_PARENT_TOP); topBarParams.setMargins(40, 40, 40, 0); rootFrame.addView(topBar, topBarParams);
		
		final android.widget.LinearLayout bottomMasterContainer = new android.widget.LinearLayout(this);
		bottomMasterContainer.setOrientation(android.widget.LinearLayout.VERTICAL); bottomMasterContainer.setGravity(android.view.Gravity.CENTER_HORIZONTAL); bottomMasterContainer.setClickable(true);
		
		final android.widget.LinearLayout audioPlayerLayout = new android.widget.LinearLayout(this);
		audioPlayerLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
		android.graphics.drawable.GradientDrawable audioBg = new android.graphics.drawable.GradientDrawable();
		audioBg.setColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#333333") : android.graphics.Color.parseColor("#4A8E4D"));
		audioBg.setCornerRadius(50f);
		audioPlayerLayout.setBackground(audioBg);
		audioPlayerLayout.setPadding(30, 30, 30, 30); audioPlayerLayout.setElevation(25f); audioPlayerLayout.setVisibility(android.view.View.GONE);
		
		// الصف العلوي لمشغل الصوت: السرعة - القارئ - إظهار/إخفاء - إيقاف
		android.widget.LinearLayout audioTopRow = new android.widget.LinearLayout(this);
		audioTopRow.setOrientation(android.widget.LinearLayout.HORIZONTAL);
		audioTopRow.setGravity(android.view.Gravity.CENTER_VERTICAL);
		
		final android.widget.Button btnAudioSpeed = new android.widget.Button(this);
		btnAudioSpeed.setText("1.0x"); btnAudioSpeed.setBackgroundColor(android.graphics.Color.TRANSPARENT);
		btnAudioSpeed.setTextColor(android.graphics.Color.parseColor("#C8E6C9"));
		btnAudioSpeed.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, -2, 1f));
		btnAudioSpeed.setGravity(android.view.Gravity.LEFT | android.view.Gravity.CENTER_VERTICAL);
		
		final android.widget.Spinner reciterSpinnerPlayer = new android.widget.Spinner(this);
		final java.util.ArrayList<String> readersDisplay = new java.util.ArrayList<>();
		readersDisplay.add("مشاري العفاسي"); readersDisplay.add("عبد الباسط عبد الصمد"); readersDisplay.add("ماهر المعيقلي");
		readersDisplay.add("ياسر الدوسري"); readersDisplay.add("سعد الغامدي");
		final java.util.ArrayList<String> readersFolders = new java.util.ArrayList<>();
		readersFolders.add("Alafasy_128kbps"); readersFolders.add("Abdul_Basit_Murattal_64kbps"); readersFolders.add("Maher_AlMuaiqly_64kbps");
		readersFolders.add("Yasser_Ad_Dussary_128kbps"); readersFolders.add("Ghamadi_40kbps");
		android.widget.ArrayAdapter<String> playerReciterAdapter = new android.widget.ArrayAdapter<>(this, android.R.layout.simple_spinner_item, readersDisplay);
		playerReciterAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		reciterSpinnerPlayer.setAdapter(playerReciterAdapter);
		String currentReaderFolder = prefs.getString("reader_folder", "Alafasy_128kbps");
		int currentReaderIdx = readersFolders.indexOf(currentReaderFolder);
		if (currentReaderIdx >= 0) reciterSpinnerPlayer.setSelection(currentReaderIdx);
		reciterSpinnerPlayer.setOnItemSelectedListener(new android.widget.AdapterView.OnItemSelectedListener() {
			    @Override public void onItemSelected(android.widget.AdapterView<?> parent, android.view.View view, int position, long id) {
				        prefs.edit().putString("reader_folder", readersFolders.get(position)).apply();
				    }
			    @Override public void onNothingSelected(android.widget.AdapterView<?> parent) {}
		});
		android.widget.LinearLayout.LayoutParams spinnerPlayerParams = new android.widget.LinearLayout.LayoutParams(0, -2, 2f);
		reciterSpinnerPlayer.setLayoutParams(spinnerPlayerParams);
		
		// زر إظهار/إخفاء الآية بجانب السرعة
		final android.widget.ToggleButton btnToggleCurrentAyah = new android.widget.ToggleButton(this);
		btnToggleCurrentAyah.setTextOn("إخفاء");
		btnToggleCurrentAyah.setTextOff("إظهار");
		btnToggleCurrentAyah.setChecked(showOnlyCurrentAyah[0]);
		btnToggleCurrentAyah.setTextColor(android.graphics.Color.WHITE);
		btnToggleCurrentAyah.setBackgroundColor(android.graphics.Color.TRANSPARENT);
		btnToggleCurrentAyah.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        showOnlyCurrentAyah[0] = btnToggleCurrentAyah.isChecked();
				        vp.getAdapter().notifyDataSetChanged();
				        verticalPagesContainer.removeAllViews();
				    }
		});
		android.widget.LinearLayout.LayoutParams toggleTopParams = new android.widget.LinearLayout.LayoutParams(0, -2, 1f);
		btnToggleCurrentAyah.setLayoutParams(toggleTopParams);
		
		final android.widget.Button btnAudioStop = new android.widget.Button(this);
		btnAudioStop.setText("✖"); btnAudioStop.setBackgroundColor(android.graphics.Color.TRANSPARENT);
		btnAudioStop.setTextColor(android.graphics.Color.WHITE);
		btnAudioStop.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, -2, 1f));
		btnAudioStop.setGravity(android.view.Gravity.RIGHT | android.view.Gravity.CENTER_VERTICAL);
		
		audioTopRow.addView(btnAudioSpeed);
		audioTopRow.addView(reciterSpinnerPlayer);
		audioTopRow.addView(btnToggleCurrentAyah);
		audioTopRow.addView(btnAudioStop);
		audioPlayerLayout.addView(audioTopRow, new android.widget.LinearLayout.LayoutParams(-1, -2));
		
		audioSeekBar.getProgressDrawable().setColorFilter(android.graphics.Color.WHITE, android.graphics.PorterDuff.Mode.SRC_IN);
		audioSeekBar.getThumb().setColorFilter(android.graphics.Color.WHITE, android.graphics.PorterDuff.Mode.SRC_IN);
		android.widget.LinearLayout.LayoutParams audioSeekParams = new android.widget.LinearLayout.LayoutParams(-1, -2);
		audioSeekParams.setMargins(0, 15, 0, 15);
		audioPlayerLayout.addView(audioSeekBar, audioSeekParams);
		
		android.widget.RelativeLayout audioBottomRow = new android.widget.RelativeLayout(this);
		audioBottomRow.setPadding(0, 10, 0, 0);
		
		final android.widget.TextView tvAudioBadge = new android.widget.TextView(this);
		android.graphics.drawable.GradientDrawable badgeBg2 = new android.graphics.drawable.GradientDrawable();
		badgeBg2.setColor(android.graphics.Color.parseColor("#FDF9F1"));
		badgeBg2.setCornerRadius(30f);
		tvAudioBadge.setBackground(badgeBg2);
		tvAudioBadge.setTextColor(android.graphics.Color.parseColor("#4A8E4D"));
		tvAudioBadge.setPadding(30, 15, 30, 15);
		tvAudioBadge.setText("سورة - آية");
		tvAudioBadge.setTextSize(14);
		tvAudioBadge.setTypeface(surahNumFont);
		android.widget.RelativeLayout.LayoutParams badgeParams2 = new android.widget.RelativeLayout.LayoutParams(-2, -2);
		badgeParams2.addRule(android.widget.RelativeLayout.ALIGN_PARENT_LEFT);
		badgeParams2.addRule(android.widget.RelativeLayout.CENTER_VERTICAL);
		tvAudioBadge.setLayoutParams(badgeParams2);
		audioBottomRow.addView(tvAudioBadge);
		
		android.widget.LinearLayout controls = new android.widget.LinearLayout(this);
		controls.setOrientation(android.widget.LinearLayout.HORIZONTAL);
		controls.setGravity(android.view.Gravity.CENTER);
		android.widget.RelativeLayout.LayoutParams controlsParams = new android.widget.RelativeLayout.LayoutParams(-2, -2);
		controlsParams.addRule(android.widget.RelativeLayout.CENTER_IN_PARENT);
		controls.setLayoutParams(controlsParams);
		
		final android.widget.Button btnAudioPrev = new android.widget.Button(this);
		btnAudioPrev.setText("⏮"); btnAudioPrev.setBackgroundColor(android.graphics.Color.TRANSPARENT);
		btnAudioPrev.setTextColor(android.graphics.Color.parseColor("#C8E6C9")); btnAudioPrev.setTextSize(26);
		
		final android.widget.Button btnAudioPlayPause = new android.widget.Button(this);
		btnAudioPlayPause.setText("⏸");
		android.graphics.drawable.GradientDrawable playBg = new android.graphics.drawable.GradientDrawable();
		playBg.setShape(android.graphics.drawable.GradientDrawable.OVAL);
		playBg.setColor(android.graphics.Color.WHITE);
		btnAudioPlayPause.setBackground(playBg);
		btnAudioPlayPause.setTextColor(android.graphics.Color.parseColor("#4A8E4D"));
		btnAudioPlayPause.setTextSize(22);
		android.widget.LinearLayout.LayoutParams playParams = new android.widget.LinearLayout.LayoutParams(140, 140);
		playParams.setMargins(30, 0, 30, 0);
		btnAudioPlayPause.setLayoutParams(playParams);
		
		final android.widget.Button btnAudioNext = new android.widget.Button(this);
		btnAudioNext.setText("⏭"); btnAudioNext.setBackgroundColor(android.graphics.Color.TRANSPARENT);
		btnAudioNext.setTextColor(android.graphics.Color.parseColor("#C8E6C9")); btnAudioNext.setTextSize(26);
		
		controls.addView(btnAudioPrev); controls.addView(btnAudioPlayPause); controls.addView(btnAudioNext);
		audioBottomRow.addView(controls);
		
		final android.widget.Button btnAudioRepeat = new android.widget.Button(this);
		btnAudioRepeat.setText("🔁 1x"); btnAudioRepeat.setBackgroundColor(android.graphics.Color.TRANSPARENT);
		btnAudioRepeat.setTextColor(android.graphics.Color.parseColor("#C8E6C9")); btnAudioRepeat.setTextSize(18);
		android.widget.RelativeLayout.LayoutParams repeatParams = new android.widget.RelativeLayout.LayoutParams(-2, -2);
		repeatParams.addRule(android.widget.RelativeLayout.ALIGN_PARENT_RIGHT);
		repeatParams.addRule(android.widget.RelativeLayout.CENTER_VERTICAL);
		btnAudioRepeat.setLayoutParams(repeatParams);
		audioBottomRow.addView(btnAudioRepeat);
		
		final android.widget.Button btnAudioDownload = new android.widget.Button(this);
		btnAudioDownload.setText("⬇"); btnAudioDownload.setBackgroundColor(android.graphics.Color.TRANSPARENT);
		btnAudioDownload.setTextColor(android.graphics.Color.parseColor("#FFD700")); btnAudioDownload.setTextSize(18);
		android.widget.RelativeLayout.LayoutParams downParams = new android.widget.RelativeLayout.LayoutParams(-2, -2);
		downParams.addRule(android.widget.RelativeLayout.LEFT_OF, btnAudioRepeat.getId());
		downParams.addRule(android.widget.RelativeLayout.CENTER_VERTICAL);
		downParams.setMargins(0, 0, 20, 0);
		btnAudioDownload.setLayoutParams(downParams);
		audioBottomRow.addView(btnAudioDownload);
		
		audioPlayerLayout.addView(audioBottomRow, new android.widget.LinearLayout.LayoutParams(-1, -2));
		bottomMasterContainer.addView(audioPlayerLayout, new android.widget.LinearLayout.LayoutParams(-1, -2));
		
		audioProgressRunnable[0] = new Runnable() {
			    @Override public void run() {
				        if (quranPlayer[0] != null && quranPlayer[0].isPlaying()) {
					            audioSeekBar.setProgress(quranPlayer[0].getCurrentPosition());
					        }
				        audioProgressHandler.postDelayed(this, 100);
				    }
		};
		
		audioSeekBar.setOnSeekBarChangeListener(new android.widget.SeekBar.OnSeekBarChangeListener() {
			    @Override public void onProgressChanged(android.widget.SeekBar seekBar, int progress, boolean fromUser) {
				        if (fromUser && quranPlayer[0] != null) { quranPlayer[0].seekTo(progress); }
				    }
			    @Override public void onStartTrackingTouch(android.widget.SeekBar seekBar) {}
			    @Override public void onStopTrackingTouch(android.widget.SeekBar seekBar) {}
		});
		
		final android.widget.TextView floatingBadge = new android.widget.TextView(this);
		android.graphics.drawable.GradientDrawable badgeBg = new android.graphics.drawable.GradientDrawable();
		badgeBg.setColor(android.graphics.Color.parseColor("#CC387046")); badgeBg.setCornerRadius(25f);
		floatingBadge.setBackground(badgeBg); floatingBadge.setTextColor(android.graphics.Color.WHITE);
		floatingBadge.setPadding(25, 10, 25, 10); floatingBadge.setTextSize(14);
		floatingBadge.setGravity(android.view.Gravity.CENTER); floatingBadge.setVisibility(android.view.View.GONE);
		bottomMasterContainer.addView(floatingBadge, new android.widget.LinearLayout.LayoutParams(-2, -2));
		
		final android.widget.LinearLayout seekContainer = new android.widget.LinearLayout(this);
		seekContainer.setOrientation(android.widget.LinearLayout.VERTICAL); seekContainer.setBackground(barsBg);
		seekContainer.setPadding(20, 20, 20, 20); seekContainer.setVisibility(android.view.View.GONE);
		final android.widget.SeekBar jumpSeekBar = new android.widget.SeekBar(this);
		jumpSeekBar.getProgressDrawable().setColorFilter(android.graphics.Color.WHITE, android.graphics.PorterDuff.Mode.SRC_IN);
		jumpSeekBar.getThumb().setColorFilter(android.graphics.Color.WHITE, android.graphics.PorterDuff.Mode.SRC_IN);
		jumpSeekBar.setMax(sortedPages.size() - 1);
		seekContainer.addView(jumpSeekBar, new android.widget.LinearLayout.LayoutParams(-1, -2));
		android.widget.LinearLayout.LayoutParams seekParams = new android.widget.LinearLayout.LayoutParams(-1, -2);
		seekParams.setMargins(0, 0, 0, 20);
		bottomMasterContainer.addView(seekContainer, seekParams);
		
		final android.widget.LinearLayout bottomIconsLayout = new android.widget.LinearLayout(this);
		bottomIconsLayout.setOrientation(android.widget.LinearLayout.HORIZONTAL); bottomIconsLayout.setBackground(barsBg);
		bottomIconsLayout.setGravity(android.view.Gravity.CENTER_VERTICAL); bottomIconsLayout.setPadding(20, 20, 20, 20);
		bottomIconsLayout.setVisibility(android.view.View.GONE);
		
		final android.widget.ImageView btnReciter = new android.widget.ImageView(this); btnReciter.setImageResource(R.drawable.ic_menu);
		final android.widget.ImageView btnPlay = new android.widget.ImageView(this); btnPlay.setImageResource(R.drawable.ic_play);
		final android.widget.ImageView btnAutoScroll = new android.widget.ImageView(this); try { btnAutoScroll.setImageResource(R.drawable.ic_scroll); } catch(Exception e){}
		final android.widget.ImageView btnHifz = new android.widget.ImageView(this); btnHifz.setImageResource(R.drawable.ic_eye);
		
		android.view.View sp1 = new android.view.View(this); sp1.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, 0, 1f));
		android.view.View sp2 = new android.view.View(this); sp2.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, 0, 1f));
		android.view.View sp3 = new android.view.View(this); sp3.setLayoutParams(new android.widget.LinearLayout.LayoutParams(0, 0, 1f));
		
		bottomIconsLayout.addView(btnReciter, iconParams); bottomIconsLayout.addView(sp1);
		bottomIconsLayout.addView(btnAutoScroll, iconParams); bottomIconsLayout.addView(sp2);
		bottomIconsLayout.addView(btnPlay, iconParams); bottomIconsLayout.addView(sp3);
		bottomIconsLayout.addView(btnHifz, iconParams);
		bottomMasterContainer.addView(bottomIconsLayout, new android.widget.LinearLayout.LayoutParams(-1, -2));
		
		final android.widget.LinearLayout autoScrollControl = new android.widget.LinearLayout(this);
		autoScrollControl.setOrientation(android.widget.LinearLayout.HORIZONTAL); autoScrollControl.setBackground(barsBg);
		autoScrollControl.setGravity(android.view.Gravity.CENTER_VERTICAL); autoScrollControl.setPadding(30, 30, 30, 30);
		autoScrollControl.setVisibility(android.view.View.GONE);
		final android.widget.Button btnCloseAutoText = new android.widget.Button(this);
		btnCloseAutoText.setText("✖"); btnCloseAutoText.setBackgroundColor(android.graphics.Color.TRANSPARENT);
		btnCloseAutoText.setTextColor(android.graphics.Color.WHITE); btnCloseAutoText.setTextSize(20);
		final android.widget.SeekBar speedSeekBar = new android.widget.SeekBar(this);
		speedSeekBar.setMax(100); speedSeekBar.setProgress(70);
		speedSeekBar.getProgressDrawable().setColorFilter(android.graphics.Color.WHITE, android.graphics.PorterDuff.Mode.SRC_IN);
		speedSeekBar.getThumb().setColorFilter(android.graphics.Color.WHITE, android.graphics.PorterDuff.Mode.SRC_IN);
		autoScrollControl.addView(btnCloseAutoText, new android.widget.LinearLayout.LayoutParams(-2, -2));
		autoScrollControl.addView(speedSeekBar, new android.widget.LinearLayout.LayoutParams(0, -2, 1f));
		bottomMasterContainer.addView(autoScrollControl, new android.widget.LinearLayout.LayoutParams(-1, -2));
		
		android.widget.RelativeLayout.LayoutParams masterParams = new android.widget.RelativeLayout.LayoutParams(-1, -2);
		masterParams.addRule(android.widget.RelativeLayout.ALIGN_PARENT_BOTTOM); masterParams.setMargins(40, 0, 40, 40);
		rootFrame.addView(bottomMasterContainer, masterParams);
		
		final Runnable toggleMenus = new Runnable() {
			    @Override public void run() {
				        if (topBar.getVisibility() == android.view.View.GONE) {
					            topBar.setVisibility(android.view.View.VISIBLE); seekContainer.setVisibility(android.view.View.VISIBLE);
					            bottomIconsLayout.setVisibility(android.view.View.VISIBLE); jumpSeekBar.setProgress(vp.getCurrentItem());
					        } else {
					            topBar.setVisibility(android.view.View.GONE); seekContainer.setVisibility(android.view.View.GONE);
					            bottomIconsLayout.setVisibility(android.view.View.GONE); floatingBadge.setVisibility(android.view.View.GONE);
					        }
				    }
		};
		
		final Runnable autoScrollRunnable = new Runnable() {
			    @Override public void run() {
				        if (isAutoScrolling[0]) { verticalAutoScroll.scrollBy(0, 2); scrollHandler.postDelayed(this, scrollSpeedDelay[0]); }
				    }
		};
		
		// ========================================================
		// SurahHeaderSpan معدل لضمان ظهور الصورة
		// ========================================================
		class SurahHeaderSpan extends android.text.style.ReplacementSpan {
			    String surahName; android.content.Context context; boolean isDark;
			    android.graphics.Bitmap headerBitmap;
			    public SurahHeaderSpan(String name, android.content.Context ctx, boolean dark) {
				        this.surahName = name; this.context = ctx; this.isDark = dark;
				        int resId = isDark ? R.drawable.ic_night : R.drawable.surah_header;
				        try {
					            headerBitmap = android.graphics.BitmapFactory.decodeResource(ctx.getResources(), resId);
					        } catch (Exception e) {
					            headerBitmap = null;
					        }
				    }
			    @Override public int getSize(android.graphics.Paint paint, CharSequence text, int start, int end,
			                                 android.graphics.Paint.FontMetricsInt fm) {
				        float density = context.getResources().getDisplayMetrics().density;
				        if (fm != null) {
					            // تم تقليل الارتفاع من 60 إلى 45 لتوفير مساحة
					            fm.ascent = -(int)(45 * density); 
					            fm.descent = (int)(5 * density); 
					            fm.top = fm.ascent; fm.bottom = fm.descent;
					        }
				        return context.getResources().getDisplayMetrics().widthPixels - (int)(20 * density);
				    }
			    
			    @Override public void draw(android.graphics.Canvas canvas, CharSequence text, int start, int end,
			                               float x, int top, int y, int bottom, android.graphics.Paint paint) {
				        float density = context.getResources().getDisplayMetrics().density;
				        // تقليل ارتفاع الرسمة إلى 40 بدلاً من 50
				        float frameHeight = 40f * density; 
				        int width = context.getResources().getDisplayMetrics().widthPixels - (int)(20 * density);
				        float centerY = top + (bottom - top) / 2f;
				        
				        android.graphics.RectF rect = new android.graphics.RectF(x, centerY - frameHeight/2, x + width, centerY + frameHeight/2);
				        
				        if (headerBitmap != null) {
					            canvas.drawBitmap(headerBitmap, null, rect, null);
					        } else {
					            android.graphics.Paint bgPaint = new android.graphics.Paint();
					            bgPaint.setColor(isDark ? android.graphics.Color.DKGRAY : android.graphics.Color.parseColor("#E8E5D3"));
					            canvas.drawRoundRect(rect, 20, 20, bgPaint);
					        }
				        
				        android.graphics.Paint.Style oldStyle = paint.getStyle();
				        int oldColor = paint.getColor();
				        float oldTextSize = paint.getTextSize();
				        android.graphics.Paint.Align oldAlign = paint.getTextAlign();
				        
				        paint.setStyle(android.graphics.Paint.Style.FILL);
				        paint.setColor(isDark ? android.graphics.Color.WHITE : android.graphics.Color.BLACK);
				        paint.setTextSize(18f * density); 
				        paint.setTextAlign(android.graphics.Paint.Align.CENTER);
				        
				        float textY = rect.centerY() - ((paint.descent() + paint.ascent()) / 2);
				        canvas.drawText(surahName, rect.centerX(), textY, paint);
				        
				        paint.setStyle(oldStyle); paint.setColor(oldColor);
				        paint.setTextSize(oldTextSize); paint.setTextAlign(oldAlign);
				    }
			
		}
		class QuranAppHelper {
			    public android.text.SpannableStringBuilder getFormattedText(int currentPageNum) {
				        String rawText = pageTextsMap.get(currentPageNum);
				        if (rawText == null) return new android.text.SpannableStringBuilder();
				
				        android.text.SpannableStringBuilder ssb = new android.text.SpannableStringBuilder();
				        String currentFavs = bookmarksData.getString("list", "");
				        String[] parts = rawText.split("\\[@\\]");
				
				        int startWirdS = -1, startWirdA = -1, endWirdS = -1, endWirdA = -1;
				        if(prefs.getBoolean("has_khatma", false)) {
					            int compSessions = prefs.getInt("khatma_sessions_completed", 0); int kDays = prefs.getInt("khatma_days", 30);
					            int ayahsPerDay = allAyahsList.size() / (kDays > 0 ? kDays : 1);
					            int stIdx = compSessions * ayahsPerDay; int enIdx = Math.min(stIdx + ayahsPerDay - 1, allAyahsList.size() - 1);
					            if(stIdx < allAyahsList.size()) { startWirdS = allAyahsList.get(stIdx).s; startWirdA = allAyahsList.get(stIdx).a; endWirdS = allAyahsList.get(enIdx).s; endWirdA = allAyahsList.get(enIdx).a; }
					        }
				
				        int savedS = prefs.getInt("saved_sura", -1); int savedA = prefs.getInt("saved_ayah", -1);
				
				        for (int i = 0; i < parts.length - 1; i += 2) {
					            if (parts[i].trim().isEmpty()) continue;
					            String verseData = parts[i]; String meta = parts[i+1].trim();
					            String[] textAndNum = verseData.split("\\[#\\]");
					            String vText = textAndNum[0]; String vNumStr = textAndNum.length > 1 ? textAndNum[1] : "";
					
					            if(useEnglishLanguage[0]) {
						                try {
							                    String[] mParts = meta.split(":");
							                    int sNum = Integer.parseInt(mParts[0]); int aNum = Integer.parseInt(mParts[1]);
							                    String enText = enTranslations.get(sNum + ":" + aNum);
							                    if(enText != null && !enText.isEmpty()) vText = enText;
							                } catch(Exception e){}
						            }
					
					            if(!vNumStr.isEmpty()) {
						                if(!useEnglishNumbers[0]) vNumStr = vNumStr.replace('0','٠').replace('1','١').replace('2','٢').replace('3','٣').replace('4','٤').replace('5','٥').replace('6','٦').replace('7','٧').replace('8','٨').replace('9','٩');
						                vNumStr = " " + vNumStr + " ";
						            }
					
					            int sNum = 1, aNum = 1;
					            try { String[] mParts = meta.split(":"); sNum = Integer.parseInt(mParts[0]); aNum = Integer.parseInt(mParts[1]); } catch(Exception e){}
					
					            int startIdx = ssb.length(); ssb.append(vText); int afterTextIdx = ssb.length(); ssb.append(vNumStr); int afterNumIdx = ssb.length();
					            String urlData = "ayah://" + sNum + "/" + aNum;
					            ssb.setSpan(new android.text.style.URLSpan(urlData) {
						                @Override public void updateDrawState(android.text.TextPaint ds) { super.updateDrawState(ds); ds.setUnderlineText(false); }
						            }, startIdx, afterNumIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
					
					            int normalColor = currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.BLACK;
					            boolean isStartAyah = (planSurah[0] == sNum && aNum == planStartAyah[0]);
					            boolean isEndAyah = (planSurah[0] == sNum && aNum == planEndAyah[0]);
					
					            if(isTestMode[0]) {
						                int revealedMax = testRevealedUpToAyah.containsKey(sNum) ? testRevealedUpToAyah.get(sNum) : 0;
						                if (aNum <= revealedMax) {
							                    ssb.setSpan(new android.text.style.ForegroundColorSpan(normalColor), startIdx, afterNumIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                } else {
							                    ssb.setSpan(new android.text.style.ForegroundColorSpan(android.graphics.Color.TRANSPARENT), startIdx, afterTextIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                    ssb.setSpan(new android.text.style.ForegroundColorSpan(normalColor), afterTextIdx, afterNumIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                }
						            } else {
						                if (showOnlyCurrentAyah[0]) {
							                    if (sNum == currentAudioSurah[0] && aNum == currentAudioAyah[0]) {
								                        ssb.setSpan(new android.text.style.ForegroundColorSpan(normalColor), startIdx, afterNumIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
								                    } else {
								                        ssb.setSpan(new android.text.style.ForegroundColorSpan(android.graphics.Color.TRANSPARENT), startIdx, afterTextIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
								                        ssb.setSpan(new android.text.style.ForegroundColorSpan(normalColor), afterTextIdx, afterNumIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
								                    }
							                } else {
							                    ssb.setSpan(new android.text.style.ForegroundColorSpan(normalColor), startIdx, afterNumIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                }
						                if (isStartAyah || isEndAyah) {
							                    int planColor = currentIsDarkMode[0] ? android.graphics.Color.parseColor("#803855A0") : android.graphics.Color.parseColor("#80B3E5FC");
							                    ssb.setSpan(new android.text.style.BackgroundColorSpan(planColor), startIdx, afterNumIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                }
						                if (currentFavs.contains(sNum + ":" + aNum + ",")) {
							                    int favColor = currentIsDarkMode[0] ? android.graphics.Color.parseColor("#423700") : android.graphics.Color.parseColor("#FFF9C4");
							                    ssb.setSpan(new android.text.style.BackgroundColorSpan(favColor), startIdx, afterNumIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                }
						                if (sNum == currentAudioSurah[0] && aNum == currentAudioAyah[0]) {
							                    int playBgColor = currentIsDarkMode[0] ? android.graphics.Color.parseColor("#827717") : android.graphics.Color.parseColor("#FFF9C4");
							                    ssb.setSpan(new android.text.style.BackgroundColorSpan(playBgColor), startIdx, afterNumIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                }
						                if((sNum == startWirdS && aNum == startWirdA) || (sNum == endWirdS && aNum == endWirdA)) {
							                    ssb.setSpan(new android.text.style.BackgroundColorSpan(android.graphics.Color.parseColor("#80B3E5FC")), startIdx, afterNumIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                }
						                if(sNum == savedS && aNum == savedA) {
							                    ssb.setSpan(new android.text.style.BackgroundColorSpan(android.graphics.Color.parseColor("#80FFD54F")), startIdx, afterNumIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                }
						                if (sNum == searchedSurah[0] && aNum == searchedAyah[0]) {
							                    int searchHighlightColor = currentIsDarkMode[0] ? android.graphics.Color.parseColor("#4A8E4D") : android.graphics.Color.parseColor("#C8E6C9");
							                    ssb.setSpan(new android.text.style.BackgroundColorSpan(searchHighlightColor), startIdx, afterNumIdx, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                }
						            }
					        }
				
				                                String finalStr = ssb.toString(); int searchIdx = 0;
				        while ((searchIdx = finalStr.indexOf("[SH]", searchIdx)) != -1) {
					            int endTag = finalStr.indexOf("[SH]", searchIdx + 4);
					            if (endTag != -1) {
						                String srhName = finalStr.substring(searchIdx + 4, endTag);
						                ssb.delete(searchIdx, endTag + 4);
						                
						                // الشرط الجديد: إذا كان الإطار في أول الصفحة لا نضع سطر جديد قبله
						                if (searchIdx == 0) {
							                    ssb.insert(searchIdx, "\uFFFC");
							                    SurahHeaderSpan span = new SurahHeaderSpan(srhName, getApplicationContext(), currentIsDarkMode[0]);
							                    ssb.setSpan(span, searchIdx, searchIdx + 1, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                } else {
							                    ssb.insert(searchIdx, "\n\uFFFC");
							                    SurahHeaderSpan span = new SurahHeaderSpan(srhName, getApplicationContext(), currentIsDarkMode[0]);
							                    ssb.setSpan(span, searchIdx + 1, searchIdx + 2, android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                }
						                
						                finalStr = ssb.toString();
						            } else break;
					        }
				        return ssb;
				     } 
			
			    public void playAudio(int sIdx, int aIdx) {
				        try {
					            if (quranPlayer[0] == null) {
						                quranPlayer[0] = new android.media.MediaPlayer();
						                quranPlayer[0].setOnPreparedListener(new android.media.MediaPlayer.OnPreparedListener() {
							                    @Override public void onPrepared(android.media.MediaPlayer mp) {
								                        mp.start(); btnAudioPlayPause.setText("⏸"); audioSeekBar.setMax(mp.getDuration());
								                        audioProgressHandler.postDelayed(audioProgressRunnable[0], 100);
								                        if(android.os.Build.VERSION.SDK_INT >= 23) {
									                            float speed = prefs.getFloat("speed_val", 1.0f);
									                            mp.setPlaybackParams(mp.getPlaybackParams().setSpeed(speed));
									                        }
								                    }
							                });
						                quranPlayer[0].setOnCompletionListener(new android.media.MediaPlayer.OnCompletionListener() {
							                    @Override public void onCompletion(android.media.MediaPlayer mp) {
								                        if (playSingleAyahOnly[0]) { playSingleAyahOnly[0] = false; btnAudioPlayPause.setText("▶"); return; }
								                        int maxRepeats = currentRepeatMode[0] == 0 ? 1 : (currentRepeatMode[0] == 1 ? 2 : (currentRepeatMode[0] == 2 ? 3 : Integer.MAX_VALUE));
								                        if (currentRepeatCount[0] < maxRepeats - 1) {
									                            currentRepeatCount[0]++;
									                            playAudio(currentAudioSurah[0], currentAudioAyah[0]);
									                        } else {
									                            currentRepeatCount[0] = 0;
									                            if (currentAudioAyah[0] < totalAyahsPerSurah[currentAudioSurah[0]]) {
										                                playAudio(currentAudioSurah[0], currentAudioAyah[0] + 1);
										                            } else if (currentAudioSurah[0] < 114) {
										                                playAudio(currentAudioSurah[0] + 1, 1);
										                            }
									                        }
								                    }
							                });
						            } else { quranPlayer[0].reset(); }
					
					            currentAudioSurah[0] = sIdx; currentAudioAyah[0] = aIdx; audioPlayerLayout.setVisibility(android.view.View.VISIBLE);
					            String sName = useEnglishLanguage[0] ? "Surah " + sIdx : "سورة " + sIdx;
					            if(sIdx > 0 && sIdx <= surahNamesList.size()) sName = surahNamesList.get(sIdx - 1);
					            tvAudioBadge.setText(sName + " | " + (useEnglishLanguage[0] ? "Ayah " : "الآية ") + aIdx);
					            vp.getAdapter().notifyDataSetChanged();
					
					            final String reader = prefs.getString("reader_folder", "Alafasy_128kbps");
					            final String fileName = String.format(java.util.Locale.US, "%03d%03d.mp3", sIdx, aIdx);
					            final java.io.File file = new java.io.File(getExternalFilesDir(null), "quran_audio/" + reader + "/" + fileName);
					
					            if (file.exists() && file.length() > 5000) {
						                quranPlayer[0].setDataSource(getApplicationContext(), android.net.Uri.fromFile(file));
						                quranPlayer[0].prepareAsync();
						            } else {
						                new Thread(new Runnable() {
							                    @Override public void run() {
								                        try {
									                            java.net.URL url = new java.net.URL("https://everyayah.com/data/" + reader + "/" + fileName);
									                            java.net.HttpURLConnection connection = (java.net.HttpURLConnection) url.openConnection();
									                            connection.setConnectTimeout(5000); connection.setReadTimeout(5000);
									                            connection.setRequestProperty("User-Agent", "QuranApp");
									                            connection.connect();
									
									                            if (connection.getResponseCode() != java.net.HttpURLConnection.HTTP_OK) {
										                                throw new java.io.IOException("HTTP " + connection.getResponseCode());
										                            }
									
									                            java.io.InputStream input = connection.getInputStream();
									                            java.io.FileOutputStream output = new java.io.FileOutputStream(file);
									                            byte[] buffer = new byte[4096]; int bytesRead;
									                            while ((bytesRead = input.read(buffer)) != -1) { output.write(buffer, 0, bytesRead); }
									                            output.close(); input.close(); connection.disconnect();
									
									                            runOnUiThread(new Runnable() {
										                                @Override public void run() {
											                                    try {
												                                        quranPlayer[0].setDataSource(getApplicationContext(), android.net.Uri.fromFile(file));
												                                        quranPlayer[0].prepareAsync();
												                                    } catch (Exception e) {}
											                                }
										                            });
									                        } catch (Exception e) {
									                            runOnUiThread(new Runnable() {
										                                @Override public void run() {
											                                    android.widget.Toast.makeText(ReadingActivity.this, "تعذر تحميل الصوت", android.widget.Toast.LENGTH_SHORT).show();
											                                }
										                            });
									                        }
								                    }
							                }).start();
						            }
					        } catch (Exception e) {}
				    }
			
			    public void showSearchDialog() {
				        final android.app.Dialog dialog = new android.app.Dialog(ReadingActivity.this);
				        dialog.requestWindowFeature(android.view.Window.FEATURE_NO_TITLE);
				        android.widget.LinearLayout root = new android.widget.LinearLayout(ReadingActivity.this);
				        root.setOrientation(android.widget.LinearLayout.VERTICAL);
				        root.setBackgroundColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#1E1E1E") : android.graphics.Color.parseColor("#FDF6E3"));
				        root.setPadding(30,30,30,30);
				        final android.widget.EditText searchInput = new android.widget.EditText(ReadingActivity.this);
				        searchInput.setHint(useEnglishLanguage[0] ? "Search Surah..." : "ابحث عن اسم السورة...");
				        searchInput.setBackgroundColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#333333") : android.graphics.Color.WHITE);
				        searchInput.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.BLACK);
				        searchInput.setPadding(30,30,30,30); searchInput.setTextSize(18);
				        root.addView(searchInput, new android.widget.LinearLayout.LayoutParams(-1, -2));
				        android.widget.ScrollView scroll = new android.widget.ScrollView(ReadingActivity.this);
				        final android.widget.LinearLayout listLayout = new android.widget.LinearLayout(ReadingActivity.this);
				        listLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
				
				        final Runnable updateList = new Runnable() {
					            @Override public void run() {
						                listLayout.removeAllViews(); String query = searchInput.getText().toString().trim();
						                for(int i = 0; i < surahNamesList.size(); i++) {
							                    final int index = i;
							                    if(!query.isEmpty() && !surahNamesList.get(i).contains(query)) continue;
							                    android.widget.LinearLayout row = new android.widget.LinearLayout(ReadingActivity.this);
							                    row.setOrientation(android.widget.LinearLayout.HORIZONTAL); row.setPadding(20,30,20,30); row.setGravity(android.view.Gravity.CENTER_VERTICAL);
							                    android.graphics.drawable.GradientDrawable rowBg = new android.graphics.drawable.GradientDrawable();
							                    rowBg.setColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.parseColor("#F5F0DC"));
							                    rowBg.setCornerRadius(20f); row.setBackground(rowBg);
							                    android.widget.TextView tvIcon = new android.widget.TextView(ReadingActivity.this); tvIcon.setTextSize(26);
							                    String sType = surahTypesList.size() > i ? surahTypesList.get(i) : "meccan";
							                    tvIcon.setText((sType.contains("medina") || sType.contains("madina") || sType.equals("مدنية")) ? "🕌" : "🕋");
							                    android.widget.TextView tvDetails = new android.widget.TextView(ReadingActivity.this);
							                    int pageIndex = surahStartPages.get(i); int realPageNum = 1;
							                    if (pageIndex < sortedPages.size() && pageIndex >= 0) realPageNum = sortedPages.get(pageIndex);
							                    tvDetails.setText((useEnglishLanguage[0] ? "Ayahs " : "الآيات ") + totalAyahsPerSurah[i+1] + "\n" + (useEnglishLanguage[0] ? "Page " : "الصفحة ") + realPageNum);
							                    tvDetails.setTextColor(android.graphics.Color.parseColor("#7CB342")); tvDetails.setGravity(android.view.Gravity.CENTER);
							                    android.widget.TextView tvName = new android.widget.TextView(ReadingActivity.this);
							                    tvName.setText(surahNamesList.get(i)); tvName.setTextSize(18); tvName.setGravity(android.view.Gravity.RIGHT);
							                    tvName.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.BLACK);
							                    android.widget.TextView tvStar = new android.widget.TextView(ReadingActivity.this);
							                    tvStar.setText(String.valueOf(i+1)); tvStar.setBackgroundColor(android.graphics.Color.parseColor("#66BB6A"));
							                    tvStar.setTextColor(android.graphics.Color.WHITE); tvStar.setPadding(15,15,15,15);
							                    android.widget.LinearLayout.LayoutParams p1 = new android.widget.LinearLayout.LayoutParams(0, -2, 1f);
							                    android.widget.LinearLayout.LayoutParams p2 = new android.widget.LinearLayout.LayoutParams(0, -2, 2f);
							                    row.addView(tvIcon); row.addView(tvDetails, p1); row.addView(tvName, p2); row.addView(tvStar);
							                    android.widget.LinearLayout.LayoutParams rowP = new android.widget.LinearLayout.LayoutParams(-1, -2); rowP.setMargins(0, 10, 0, 10);
							                    listLayout.addView(row, rowP);
							
							                    row.setOnClickListener(new android.view.View.OnClickListener() {
								                        @Override public void onClick(android.view.View v) {
									                            int targetActualPage = surahStartPages.get(index);
									                            int targetVpIndex = sortedPages.indexOf(targetActualPage);
									                            if (targetVpIndex != -1) { vp.setCurrentItem(targetVpIndex, false); }
									                            dialog.dismiss();
									                        }
								                    });
							                }
						            }
					        };
				        updateList.run();
				        searchInput.addTextChangedListener(new android.text.TextWatcher() {
					            @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
					            @Override public void onTextChanged(CharSequence s, int start, int before, int count) { updateList.run(); }
					            @Override public void afterTextChanged(android.text.Editable s) {}
					        });
				        scroll.addView(listLayout); root.addView(scroll, new android.widget.LinearLayout.LayoutParams(-1, -1));
				        dialog.setContentView(root); dialog.getWindow().setLayout(android.view.ViewGroup.LayoutParams.MATCH_PARENT, android.view.ViewGroup.LayoutParams.MATCH_PARENT);
				        dialog.show();
				    }
			
			    public void shareAyahAsImage(String ayahTxt, String tafseerTxt, String surahInfo) {
				        android.widget.LinearLayout shareLayout = new android.widget.LinearLayout(ReadingActivity.this);
				        shareLayout.setOrientation(android.widget.LinearLayout.VERTICAL); shareLayout.setPadding(50, 50, 50, 50);
				        shareLayout.setBackgroundColor(android.graphics.Color.parseColor("#FDF9F1"));
				
				        android.widget.TextView tvTitle = new android.widget.TextView(ReadingActivity.this);
				        tvTitle.setText(surahInfo); tvTitle.setTextSize(16); tvTitle.setTextColor(android.graphics.Color.parseColor("#2E7D32"));
				        tvTitle.setGravity(android.view.Gravity.CENTER); tvTitle.setPadding(0, 0, 0, 30);
				
				        android.widget.TextView tvA = new android.widget.TextView(ReadingActivity.this);
				        tvA.setText(ayahTxt); tvA.setTextSize(26); tvA.setTypeface(quranFont[0]); tvA.setTextColor(android.graphics.Color.BLACK);
				        tvA.setGravity(android.view.Gravity.CENTER); tvA.setPadding(0, 0, 0, 40);
				
				        android.widget.TextView tvT = new android.widget.TextView(ReadingActivity.this);
				        tvT.setText(tafseerTxt); tvT.setTextSize(18); tvT.setTextColor(android.graphics.Color.DKGRAY);
				        tvT.setGravity(android.view.Gravity.RIGHT);
				
				        shareLayout.addView(tvTitle); shareLayout.addView(tvA); shareLayout.addView(tvT);
				
				        int widthMeasureSpec = android.view.View.MeasureSpec.makeMeasureSpec(800, android.view.View.MeasureSpec.EXACTLY);
				        int heightMeasureSpec = android.view.View.MeasureSpec.makeMeasureSpec(0, android.view.View.MeasureSpec.UNSPECIFIED);
				        shareLayout.measure(widthMeasureSpec, heightMeasureSpec);
				        shareLayout.layout(0, 0, shareLayout.getMeasuredWidth(), shareLayout.getMeasuredHeight());
				
				        android.graphics.Bitmap bitmap = android.graphics.Bitmap.createBitmap(shareLayout.getMeasuredWidth(), shareLayout.getMeasuredHeight(), android.graphics.Bitmap.Config.ARGB_8888);
				        android.graphics.Canvas canvas = new android.graphics.Canvas(bitmap);
				        shareLayout.draw(canvas);
				
				        try {
					            String path = android.provider.MediaStore.Images.Media.insertImage(getContentResolver(), bitmap, "Ayah", null);
					            android.content.Intent shareIntent = new android.content.Intent(android.content.Intent.ACTION_SEND);
					            shareIntent.setType("image/*"); shareIntent.putExtra(android.content.Intent.EXTRA_STREAM, android.net.Uri.parse(path));
					            startActivity(android.content.Intent.createChooser(shareIntent, useEnglishLanguage[0] ? "Share Ayah" : "مشاركة الآية"));
					        } catch (Exception e) {
					            android.widget.Toast.makeText(ReadingActivity.this, useEnglishLanguage[0] ? "Failed to share image" : "فشل حفظ الصورة للمشاركة", 0).show();
					        }
				    }
			
			    public void shareAyahAsText(int sura, int aya) {
				        String ayahText = "";
				        String surahInfo = surahNamesList.get(sura - 1) + " - " + aya;
				        try {
					            java.io.InputStream is = getAssets().open("ayat.json");
					            java.util.Scanner sc = new java.util.Scanner(is).useDelimiter("\\A");
					            org.json.JSONArray surahsArray = new org.json.JSONArray(sc.hasNext() ? sc.next() : "");
					            sc.close();
					            org.json.JSONArray vs = surahsArray.getJSONObject(sura - 1).getJSONArray("verses");
					            for (int j = 0; j < vs.length(); j++) {
						                if (vs.getJSONObject(j).getInt("number") == aya) {
							                    ayahText = vs.getJSONObject(j).getJSONObject("text").getString("ar");
							                    break;
							                }
						            }
					        } catch (Exception e) {}
				
				        if(useEnglishLanguage[0]) {
					            String enText = enTranslations.get(sura + ":" + aya);
					            if(enText != null && !enText.isEmpty()) ayahText = enText;
					        }
				
				        String shareBody = surahInfo + "\n" + ayahText + "\n\n" + (useEnglishLanguage[0] ? "Shared via Khatma Al-Quran" : "بواسطة تطبيق ختمة القرآن الكريم");
				        android.content.Intent sharingIntent = new android.content.Intent(android.content.Intent.ACTION_SEND);
				        sharingIntent.setType("text/plain");
				        sharingIntent.putExtra(android.content.Intent.EXTRA_TEXT, shareBody);
				        startActivity(android.content.Intent.createChooser(sharingIntent, useEnglishLanguage[0] ? "Share Ayah" : "مشاركة الآية"));
				    }
			
			    public void showTafseerDialog(final int fSura, final int startAya) {
				        final int[] cAya = {startAya}; final int[] mode = {0};
				        final android.app.AlertDialog.Builder builder = new android.app.AlertDialog.Builder(ReadingActivity.this);
				        final android.widget.LinearLayout layout_root = new android.widget.LinearLayout(ReadingActivity.this);
				        layout_root.setOrientation(android.widget.LinearLayout.VERTICAL); layout_root.setPadding(40, 50, 40, 50);
				
				        int bgColor = currentIsDarkMode[0] ? android.graphics.Color.parseColor("#1E1E1E") : android.graphics.Color.parseColor("#FDF6E3");
				        int textColor = currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.BLACK;
				        int headerColor = currentIsDarkMode[0] ? android.graphics.Color.LTGRAY : android.graphics.Color.DKGRAY;
				        int ayahColor = currentIsDarkMode[0] ? android.graphics.Color.parseColor("#81C784") : android.graphics.Color.parseColor("#1B5E20");
				        int tafseerColor = currentIsDarkMode[0] ? android.graphics.Color.LTGRAY : android.graphics.Color.parseColor("#B3424242");
				
				        android.graphics.drawable.GradientDrawable rootBg = new android.graphics.drawable.GradientDrawable();
				        rootBg.setColor(bgColor); rootBg.setCornerRadius(60f); layout_root.setBackground(rootBg);
				
				        final android.widget.TextView tvHeader = new android.widget.TextView(ReadingActivity.this);
				        tvHeader.setTextColor(headerColor);
				        final android.widget.TextView tvAyah = new android.widget.TextView(ReadingActivity.this);
				        tvAyah.setTypeface(quranFont[0]); tvAyah.getPaint().setFakeBoldText(true);
				        tvAyah.setTextColor(ayahColor);
				        final android.widget.TextView tvTafseer = new android.widget.TextView(ReadingActivity.this);
				        tvTafseer.setPadding(30,30,30,30);
				        tvTafseer.setTypeface(quranFont[0]);
				        tvTafseer.setTextColor(tafseerColor);
				        tvTafseer.setTextIsSelectable(true);
				
				        final Runnable refreshUI = new Runnable() {
					            @Override public void run() {
						                try {
							                    String aText = "";
							                    try {
								                        java.io.InputStream isAyat = getAssets().open("ayat.json");
								                        java.util.Scanner scAyat = new java.util.Scanner(isAyat).useDelimiter("\\A");
								                        org.json.JSONArray surahsArray = new org.json.JSONArray(scAyat.hasNext() ? scAyat.next() : "");
								                        scAyat.close();
								                        org.json.JSONArray vs = surahsArray.getJSONObject(fSura - 1).getJSONArray("verses");
								                        if (cAya[0] < 1) cAya[0] = 1; if (cAya[0] > totalAyahsPerSurah[fSura]) cAya[0] = totalAyahsPerSurah[fSura];
								                        for (int j = 0; j < vs.length(); j++) {
									                            if (vs.getJSONObject(j).getInt("number") == cAya[0]) {
										                                aText = vs.getJSONObject(j).getJSONObject("text").getString("ar");
										                                break;
										                            }
									                        }
								                    } catch (Exception e) {}
							                    tvHeader.setText("سورة " + fSura + " - آية " + cAya[0]);
							                    tvHeader.setGravity(android.view.Gravity.CENTER);
							                    tvAyah.setText(aText); tvAyah.setTextSize(26);
							                    tvAyah.setGravity(android.view.Gravity.CENTER); tvAyah.setLineSpacing(0, 1.3f);
							
							                    if (mode[0] == 0) {
								                        String tafContent = "جاري البحث...";
								                        try {
									                            java.io.InputStream is = getAssets().open("almuyassar.xml");
									                            javax.xml.parsers.DocumentBuilderFactory dbf = javax.xml.parsers.DocumentBuilderFactory.newInstance();
									                            org.w3c.dom.Document doc = dbf.newDocumentBuilder().parse(is);
									                            org.w3c.dom.NodeList suras = doc.getElementsByTagName("sura");
									                            boolean found = false;
									                            for (int i = 0; i < suras.getLength(); i++) {
										                                org.w3c.dom.Element sNode = (org.w3c.dom.Element) suras.item(i);
										                                if (Integer.parseInt(sNode.getAttribute("index")) == fSura) {
											                                    org.w3c.dom.NodeList ayas = sNode.getElementsByTagName("aya");
											                                    for (int j = 0; j < ayas.getLength(); j++) {
												                                        org.w3c.dom.Element aNode = (org.w3c.dom.Element) ayas.item(j);
												                                        if (Integer.parseInt(aNode.getAttribute("index")) == cAya[0]) {
													                                            tafContent = aNode.getAttribute("text"); found = true; break;
													                                        }
												                                    }
											                                }
										                                if (found) break;
										                            }
									                            is.close();
									                        } catch(Exception e){}
								                        tvTafseer.setText(tafContent);
								                    } else if (mode[0] == 1) {
								                        String enTranslation = enTranslations.get(fSura + ":" + cAya[0]);
								                        tvTafseer.setText(enTranslation != null ? enTranslation : "Translation not found.");
								                    } else if (mode[0] == 2) {
								                        String tafContent = "جاري البحث...";
								                        try {
									                            java.io.InputStream is = getAssets().open("aljalalayn.xml");
									                            javax.xml.parsers.DocumentBuilderFactory dbf = javax.xml.parsers.DocumentBuilderFactory.newInstance();
									                            org.w3c.dom.Document doc = dbf.newDocumentBuilder().parse(is);
									                            org.w3c.dom.NodeList suras = doc.getElementsByTagName("sura");
									                            boolean found = false;
									                            for (int i = 0; i < suras.getLength(); i++) {
										                                org.w3c.dom.Element sNode = (org.w3c.dom.Element) suras.item(i);
										                                if (Integer.parseInt(sNode.getAttribute("index")) == fSura) {
											                                    org.w3c.dom.NodeList ayas = sNode.getElementsByTagName("aya");
											                                    for (int j = 0; j < ayas.getLength(); j++) {
												                                        org.w3c.dom.Element aNode = (org.w3c.dom.Element) ayas.item(j);
												                                        if (Integer.parseInt(aNode.getAttribute("index")) == cAya[0]) {
													                                            tafContent = aNode.getAttribute("text"); found = true; break;
													                                        }
												                                    }
											                                }
										                                if (found) break;
										                            }
									                            is.close();
									                        } catch(Exception e){}
								                        tvTafseer.setText(tafContent);
								                    }
							                    tvTafseer.setTextSize(22);
							                    tvTafseer.setGravity(mode[0] == 1 ? android.view.Gravity.LEFT : android.view.Gravity.RIGHT);
							                    ReadingActivity.this._setHighlighter(tvTafseer);
							                } catch (Exception e) {}
						            }
					        };
				        refreshUI.run();
				
				        layout_root.addView(tvHeader); layout_root.addView(tvAyah);
				        android.view.View div = new android.view.View(ReadingActivity.this);
				        div.setLayoutParams(new android.widget.LinearLayout.LayoutParams(-1, 2));
				        div.setBackgroundColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#444444") : android.graphics.Color.parseColor("#E0E0E0"));
				        android.widget.LinearLayout.LayoutParams divParams = (android.widget.LinearLayout.LayoutParams)div.getLayoutParams();
				        divParams.setMargins(0, 20, 0, 20); layout_root.addView(div);
				
				        android.widget.LinearLayout row1 = new android.widget.LinearLayout(ReadingActivity.this); row1.setOrientation(android.widget.LinearLayout.HORIZONTAL);
				        android.widget.LinearLayout row2 = new android.widget.LinearLayout(ReadingActivity.this); row2.setOrientation(android.widget.LinearLayout.HORIZONTAL);
				        android.widget.LinearLayout row3 = new android.widget.LinearLayout(ReadingActivity.this); row3.setOrientation(android.widget.LinearLayout.HORIZONTAL);
				
				        android.widget.LinearLayout.LayoutParams btnParams = new android.widget.LinearLayout.LayoutParams(0, -2, 1f); btnParams.setMargins(10, 10, 10, 10);
				        android.graphics.drawable.GradientDrawable btnBg = new android.graphics.drawable.GradientDrawable();
				        btnBg.setColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#424242") : android.graphics.Color.parseColor("#E8E5D3"));
				        btnBg.setCornerRadius(20f);
				        int btnTextColor = currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.BLACK;
				
				        final android.widget.Button btnPlayOnce = new android.widget.Button(ReadingActivity.this);
				        btnPlayOnce.setText(useEnglishLanguage[0] ? "Play Once" : "🔊 مرة");
				        btnPlayOnce.setBackground(btnBg); btnPlayOnce.setTextColor(btnTextColor);
				        final android.widget.Button btnPlayCont = new android.widget.Button(ReadingActivity.this);
				        btnPlayCont.setText(useEnglishLanguage[0] ? "Continuous" : "▶ مستمر");
				        btnPlayCont.setBackground(btnBg); btnPlayCont.setTextColor(btnTextColor);
				        final android.widget.Button btnTranslate = new android.widget.Button(ReadingActivity.this);
				        btnTranslate.setText(useEnglishLanguage[0] ? "English" : "🌐 ترجمة");
				        btnTranslate.setBackground(btnBg); btnTranslate.setTextColor(btnTextColor);
				        final android.widget.Button btnTafseerMuyassar = new android.widget.Button(ReadingActivity.this);
				        btnTafseerMuyassar.setText(useEnglishLanguage[0] ? "Tafseer" : "📖 الميسر");
				        btnTafseerMuyassar.setBackground(btnBg); btnTafseerMuyassar.setTextColor(btnTextColor);
				        final android.widget.Button btnTafseerJalalayn = new android.widget.Button(ReadingActivity.this);
				        btnTafseerJalalayn.setText(useEnglishLanguage[0] ? "Jalalayn" : "📖 الجلالين");
				        btnTafseerJalalayn.setBackground(btnBg); btnTafseerJalalayn.setTextColor(btnTextColor);
				        final android.widget.Button btnFav = new android.widget.Button(ReadingActivity.this);
				        btnFav.setText(useEnglishLanguage[0] ? "⭐ Favorite" : "⭐ مفضلة");
				        btnFav.setBackground(btnBg); btnFav.setTextColor(btnTextColor);
				        final android.widget.Button btnShareImg = new android.widget.Button(ReadingActivity.this);
				        btnShareImg.setText(useEnglishLanguage[0] ? "📸 Image" : "📸 صورة");
				        btnShareImg.setBackground(btnBg); btnShareImg.setTextColor(btnTextColor);
				        final android.widget.Button btnShareText = new android.widget.Button(ReadingActivity.this);
				        btnShareText.setText(useEnglishLanguage[0] ? "📤 Text" : "📤 نص");
				        btnShareText.setBackground(btnBg); btnShareText.setTextColor(btnTextColor);
				
				        row1.addView(btnPlayOnce, btnParams); row1.addView(btnPlayCont, btnParams);
				        if(getIntent().getBooleanExtra("continue_khatma", false)) {
					            final android.widget.Button btnSavePos = new android.widget.Button(ReadingActivity.this);
					            btnSavePos.setText(useEnglishLanguage[0] ? "📌 Save" : "📌 موضع");
					            btnSavePos.setBackground(btnBg); btnSavePos.setTextColor(android.graphics.Color.parseColor("#1976D2"));
					            row1.addView(btnSavePos, btnParams);
					            btnSavePos.setOnClickListener(new android.view.View.OnClickListener() {
						                @Override public void onClick(android.view.View v) {
							                    prefs.edit().putInt("saved_sura", fSura).putInt("saved_ayah", cAya[0]).apply();
							                    android.widget.Toast.makeText(ReadingActivity.this, useEnglishLanguage[0] ? "Position saved" : "تم حفظ الموضع بنجاح للختمة", 0).show();
							                    vp.getAdapter().notifyDataSetChanged();
							                }
						            });
					        }
				
				        row2.addView(btnTafseerMuyassar, btnParams); row2.addView(btnTafseerJalalayn, btnParams); row2.addView(btnTranslate, btnParams);
				        row3.addView(btnFav, btnParams); row3.addView(btnShareImg, btnParams); row3.addView(btnShareText, btnParams);
				        layout_root.addView(row1); layout_root.addView(row2); layout_root.addView(row3);
				
				        android.view.View div2 = new android.view.View(ReadingActivity.this);
				        div2.setLayoutParams(new android.widget.LinearLayout.LayoutParams(-1, 2));
				        div2.setBackgroundColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#444444") : android.graphics.Color.parseColor("#E0E0E0"));
				        android.widget.LinearLayout.LayoutParams divParams2 = (android.widget.LinearLayout.LayoutParams)div2.getLayoutParams();
				        divParams2.setMargins(0, 20, 0, 20); layout_root.addView(div2); layout_root.addView(tvTafseer);
				
				        btnShareImg.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                shareAyahAsImage(tvAyah.getText().toString(), tvTafseer.getText().toString(), tvHeader.getText().toString());
						            }
					        });
				        btnShareText.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                shareAyahAsText(fSura, cAya[0]);
						            }
					        });
				        btnPlayOnce.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                if (quranPlayer[0] != null && quranPlayer[0].isPlaying() && playSingleAyahOnly[0]) {
							                    quranPlayer[0].pause(); btnPlayOnce.setText(useEnglishLanguage[0] ? "Play Once" : "🔊 مرة واحدة");
							                } else {
							                    playSingleAyahOnly[0] = true; playAudio(fSura, cAya[0]);
							                    btnPlayOnce.setText(useEnglishLanguage[0] ? "⏸ Pause" : "⏸ إيقاف");
							                }
						            }
					        });
				        btnPlayCont.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                playSingleAyahOnly[0] = false; playAudio(fSura, cAya[0]);
						            }
					        });
				        btnTafseerMuyassar.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) { mode[0] = 0; refreshUI.run(); }
					        });
				        btnTafseerJalalayn.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) { mode[0] = 2; refreshUI.run(); }
					        });
				        btnTranslate.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) { mode[0] = 1; refreshUI.run(); }
					        });
				        btnFav.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                String currentList = bookmarksData.getString("list", "");
						                String newItem = fSura + ":" + cAya[0] + ",";
						                if (!currentList.contains(newItem)) {
							                    bookmarksData.edit().putString("list", currentList + newItem).apply();
							                    android.widget.Toast.makeText(getApplicationContext(), useEnglishLanguage[0] ? "Added to favorites" : "تمت الإضافة للمفضلة", 0).show();
							                }
						            }
					        });
				
				        final android.widget.ScrollView scroll_main = new android.widget.ScrollView(ReadingActivity.this); scroll_main.addView(layout_root); builder.setView(scroll_main);
				        final android.view.GestureDetector detector = new android.view.GestureDetector(ReadingActivity.this, new android.view.GestureDetector.SimpleOnGestureListener() {
					            @Override public boolean onFling(android.view.MotionEvent e1, android.view.MotionEvent e2, float vX, float vY) {
						                float diffX = e2.getX() - e1.getX();
						                if (Math.abs(diffX) > 100) {
							                    if (diffX > 0) { if(cAya[0] < totalAyahsPerSurah[fSura]) { cAya[0]++; refreshUI.run(); } }
							                    else { if (cAya[0] > 1) { cAya[0]--; refreshUI.run(); } }
							                    return true;
							                }
						                return false;
						            }
					        });
				        android.view.View.OnTouchListener swipeListener = new android.view.View.OnTouchListener() {
					            @Override public boolean onTouch(android.view.View v, android.view.MotionEvent event) { detector.onTouchEvent(event); return false; }
					        };
				        scroll_main.setOnTouchListener(swipeListener); tvTafseer.setOnTouchListener(swipeListener);
				        final android.app.AlertDialog dialog = builder.create();
				        dialog.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.TRANSPARENT));
				        dialog.show();
				    }
		}
		final QuranAppHelper helper = new QuranAppHelper();
		
		// ========================================================
		// أيقونة الخطة المحسّنة (تظهر عند وجود planSurah)
		// ========================================================
		if (planSurah[0] != -1) {
			    final android.widget.Button btnPlanMode = new android.widget.Button(this);
			    btnPlanMode.setText("📖"); btnPlanMode.setTextColor(android.graphics.Color.parseColor("#F5F0DC")); btnPlanMode.setTextSize(18);
			    android.graphics.drawable.GradientDrawable btnModeBg = new android.graphics.drawable.GradientDrawable();
			    btnModeBg.setColor(android.graphics.Color.parseColor("#385E43")); btnModeBg.setCornerRadius(100f);
			    btnPlanMode.setBackground(btnModeBg);
			    android.widget.RelativeLayout.LayoutParams btnMParams = new android.widget.RelativeLayout.LayoutParams((int)(50*density), (int)(50*density));
			    btnMParams.setMargins(0, (int)(15*density), (int)(15*density), 0);
			    btnMParams.addRule(android.widget.RelativeLayout.ALIGN_PARENT_RIGHT);
			    btnMParams.addRule(android.widget.RelativeLayout.ALIGN_PARENT_TOP);
			    btnPlanMode.setLayoutParams(btnMParams);
			    rootFrame.addView(btnPlanMode);
			
			    final android.widget.RelativeLayout planPopupContainer = new android.widget.RelativeLayout(this);
			    android.widget.RelativeLayout.LayoutParams contParams = new android.widget.RelativeLayout.LayoutParams(-1, -2);
			    contParams.setMargins((int)(20*density), (int)(80*density), (int)(20*density), 0);
			    planPopupContainer.setLayoutParams(contParams);
			    planPopupContainer.setVisibility(android.view.View.GONE);
			    rootFrame.addView(planPopupContainer);
			
			    final android.widget.LinearLayout planPopupCard = new android.widget.LinearLayout(this);
			    planPopupCard.setOrientation(android.widget.LinearLayout.VERTICAL);
			    planPopupCard.setPadding((int)(15*density), (int)(15*density), (int)(15*density), (int)(15*density));
			    android.graphics.drawable.GradientDrawable popBg = new android.graphics.drawable.GradientDrawable();
			    popBg.setColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.parseColor("#F1EBD9"));
			    popBg.setCornerRadius(40f); popBg.setStroke(3, android.graphics.Color.parseColor("#A3B899"));
			    planPopupCard.setBackground(popBg);
			    planPopupCard.setElevation(15f);
			    planPopupCard.setLayoutParams(new android.widget.RelativeLayout.LayoutParams(-1, -2));
			    planPopupContainer.addView(planPopupCard);
			
			    final android.widget.TextView tvPlanTitle = new android.widget.TextView(this);
			    tvPlanTitle.setText("ورد اليوم: " + surahNamesList.get(planSurah[0] - 1));
			    tvPlanTitle.setTextSize(16);
			    tvPlanTitle.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.parseColor("#385E43"));
			    tvPlanTitle.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
			    tvPlanTitle.setGravity(android.view.Gravity.CENTER);
			    tvPlanTitle.setPadding(0, 0, 0, (int)(15*density));
			    planPopupCard.addView(tvPlanTitle);
			
			    final android.widget.TextView tvPlanRange = new android.widget.TextView(this);
			    tvPlanRange.setText("من الآية " + planStartAyah[0] + " إلى " + planEndAyah[0]);
			    tvPlanRange.setTextSize(14);
			    tvPlanRange.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.LTGRAY : android.graphics.Color.DKGRAY);
			    tvPlanRange.setGravity(android.view.Gravity.CENTER);
			    tvPlanRange.setPadding(0, 0, 0, (int)(15*density));
			    planPopupCard.addView(tvPlanRange);
			
			    int surahIndex = planSurah[0] - 1;
			   final int totalAyahsInSurah = totalAyahsPerSurah[planSurah[0]];
			    int savedVerses = 0;
			    try { savedVerses = Integer.parseInt(memoData.getString("surah_" + planSurah[0] + "_saved", "0")); } catch(Exception e){}
			   final float surahPercent = totalAyahsInSurah > 0 ? ((float) savedVerses / totalAyahsInSurah) * 100f : 0f;
			
			    final android.widget.TextView tvSavedCount = new android.widget.TextView(this);
			    tvSavedCount.setText("محفوظ: " + savedVerses + " / " + totalAyahsInSurah + " آية");
			    tvSavedCount.setTextSize(14);
			    tvSavedCount.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.LTGRAY : android.graphics.Color.DKGRAY);
			    tvSavedCount.setGravity(android.view.Gravity.CENTER);
			    planPopupCard.addView(tvSavedCount);
			
			   final android.widget.ProgressBar surahProgressBar = new android.widget.ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal);
			    surahProgressBar.setMax(100);
			    surahProgressBar.setProgress((int) surahPercent);
			    surahProgressBar.setScaleY(1.5f);
			    surahProgressBar.getProgressDrawable().setColorFilter(android.graphics.Color.parseColor("#4CAF50"), android.graphics.PorterDuff.Mode.SRC_IN);
			    android.widget.LinearLayout.LayoutParams pbParams = new android.widget.LinearLayout.LayoutParams(-1, -2);
			    pbParams.setMargins(0, 15, 0, 0);
			    surahProgressBar.setLayoutParams(pbParams);
			    planPopupCard.addView(surahProgressBar);
			
			    btnPlanMode.setOnClickListener(new android.view.View.OnClickListener() {
				        @Override public void onClick(android.view.View v) {
					            if (planPopupContainer.getVisibility() == android.view.View.VISIBLE) {
						                planPopupContainer.setVisibility(android.view.View.GONE);
						            } else {
						                int saved = 0;
						                try { saved = Integer.parseInt(memoData.getString("surah_" + planSurah[0] + "_saved", "0")); } catch(Exception e){}
						                tvSavedCount.setText("محفوظ: " + saved + " / " + totalAyahsInSurah + " آية");
						                float percent = totalAyahsInSurah > 0 ? ((float) saved / totalAyahsInSurah) * 100f : 0f;
						                surahProgressBar.setProgress((int) percent);
						                planPopupContainer.setVisibility(android.view.View.VISIBLE);
						            }
					        }
				    });
		}
		
		// ========================================================
		// ViewPager والإعدادات النهائية
		// ========================================================
		vp.addOnPageChangeListener(new androidx.viewpager.widget.ViewPager.OnPageChangeListener() {
			    @Override public void onPageScrolled(int p, float po, int pop) {}
			    @Override public void onPageScrollStateChanged(int s) {}
			    @Override public void onPageSelected(int p) {
				        prefs.edit().putInt("last_page", p).putInt("last_read_page_index", p).apply();
				        if(isTestMode[0]) { testRevealedUpToAyah.clear(); vp.getAdapter().notifyDataSetChanged(); }
				        if(bottomIconsLayout.getVisibility() == android.view.View.VISIBLE) { jumpSeekBar.setProgress(p); }
				    }
		});
		
		vp.setAdapter(new androidx.viewpager.widget.PagerAdapter() {
			    @Override public int getCount() { return sortedPages.size(); }
			    @Override public boolean isViewFromObject(android.view.View v, Object o) { return v == o; }
			    @Override public int getItemPosition(Object object) { return POSITION_NONE; }
			
			    @Override public Object instantiateItem(final android.view.ViewGroup c, final int p) {
				        int currentPageNum = sortedPages.get(p);
				        android.widget.RelativeLayout pageContainer = new android.widget.RelativeLayout(c.getContext());
				        pageContainer.setPadding(0, 0, 0, 0);
				
				        android.widget.RelativeLayout headerLayout = new android.widget.RelativeLayout(c.getContext());
				        headerLayout.setId(android.view.View.generateViewId());
				        android.widget.RelativeLayout.LayoutParams headerLp = new android.widget.RelativeLayout.LayoutParams(-1, -2);
				        headerLp.setMargins(0, 40, 0, 0);
				        headerLayout.setLayoutParams(headerLp);
				
				        android.widget.TextView txtSurah = new android.widget.TextView(c.getContext());
				        txtSurah.setText(pageSurahMap.get(currentPageNum)); txtSurah.setTextSize(14);
				        txtSurah.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.LTGRAY : android.graphics.Color.BLACK);
				        android.widget.TextView txtJuz = new android.widget.TextView(c.getContext());
				        txtJuz.setText(pageJuzMap.get(currentPageNum)); txtJuz.setTextSize(14);
				        txtJuz.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.LTGRAY : android.graphics.Color.BLACK);
				        android.widget.RelativeLayout.LayoutParams pSurah = new android.widget.RelativeLayout.LayoutParams(-2, -2);
				        pSurah.addRule(android.widget.RelativeLayout.ALIGN_PARENT_LEFT); pSurah.setMargins(30, 0, 0, 0);
				        android.widget.RelativeLayout.LayoutParams pJuz = new android.widget.RelativeLayout.LayoutParams(-2, -2);
				        pJuz.addRule(android.widget.RelativeLayout.ALIGN_PARENT_RIGHT); pJuz.setMargins(0, 0, 30, 0);
				        headerLayout.addView(txtSurah, pSurah); headerLayout.addView(txtJuz, pJuz);
				
				        android.widget.TextView txtPageNum = new android.widget.TextView(c.getContext());
				        txtPageNum.setId(android.view.View.generateViewId()); txtPageNum.setText(String.valueOf(currentPageNum));
				        txtPageNum.setTextSize(16); txtPageNum.setGravity(android.view.Gravity.CENTER);
				        txtPageNum.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.BLACK);
				        android.widget.RelativeLayout.LayoutParams pFooter = new android.widget.RelativeLayout.LayoutParams(-2, -2);
				        pFooter.addRule(android.widget.RelativeLayout.ALIGN_PARENT_BOTTOM);
				        pFooter.addRule(android.widget.RelativeLayout.CENTER_HORIZONTAL);
				        pFooter.setMargins(0, 0, 0, 60);
				        txtPageNum.setLayoutParams(pFooter);
				
				                final android.widget.TextView content = new android.widget.TextView(c.getContext());
				        // تحديد حجم الخط الافتراضي
				        content.setTextSize(android.util.TypedValue.COMPLEX_UNIT_SP, currentFontSize[0]);
				        content.setTypeface(quranFont[0]);
				        // تم تقليل تباعد الأسطر من 1.2 إلى 1.05 لتوفير مساحة عمودية للآيات
				        content.setLineSpacing(0f, 1.05f);
				        content.setGravity(android.view.Gravity.CENTER);
				        content.setTextDirection(android.view.View.TEXT_DIRECTION_RTL);
				        content.setIncludeFontPadding(false);
				        content.setText(helper.getFormattedText(currentPageNum));
				
				        // الحل السحري: تفعيل التحجيم التلقائي ليتقلص الخط تلقائياً إذا كانت الصفحة مزدحمة
				        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
					            content.setAutoSizeTextTypeUniformWithConfiguration(
					                    12, // أصغر حجم ممكن للخط
					                    (int) Math.max(currentFontSize[0], 12), // أكبر حجم (حسب اختيار المستخدم)
					                    1, // مقدار التدرج في التصغير
					                    android.util.TypedValue.COMPLEX_UNIT_SP);
					        }
				
				        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
					            content.setJustificationMode(android.text.Layout.JUSTIFICATION_MODE_INTER_WORD);
					        }
				
				        content.setOnTouchListener(new android.view.View.OnTouchListener() {
					            android.view.GestureDetector gd = new android.view.GestureDetector(ReadingActivity.this, new android.view.GestureDetector.SimpleOnGestureListener() {
						                @Override public boolean onDown(android.view.MotionEvent e) { return true; }
						                @Override public void onLongPress(android.view.MotionEvent e) { handleTouch(e, true); }
						                @Override public boolean onSingleTapConfirmed(android.view.MotionEvent e) { handleTouch(e, false); return true; }
						
						                private void handleTouch(android.view.MotionEvent e, boolean isLongPress) {
							                    try {
								                        int x = (int) e.getX() - content.getTotalPaddingLeft() + content.getScrollX();
								                        int y = (int) e.getY() - content.getTotalPaddingTop() + content.getScrollY();
								                        android.text.Layout layout = content.getLayout(); if(layout == null) return;
								                        int line = layout.getLineForVertical(y);
								                        if (x < layout.getLineLeft(line) || x > layout.getLineRight(line)) { if(!isLongPress) toggleMenus.run(); return; }
								                        int off = layout.getOffsetForHorizontal(line, x); CharSequence text = content.getText();
								                        if (text instanceof android.text.Spanned) {
									                            android.text.Spanned spanned = (android.text.Spanned) text;
									                            android.text.style.URLSpan[] link = spanned.getSpans(off, off, android.text.style.URLSpan.class);
									                            if (link != null && link.length > 0) {
										                                String[] parts = link[0].getURL().split("/");
										                                if(parts.length >= 4) {
											                                    int sNum = Integer.parseInt(parts[2]); int aNum = Integer.parseInt(parts[3]);
											                                    if (isLongPress) {
												                                        if(autoPlayOnLongPress[0]) { playSingleAyahOnly[0] = true; helper.playAudio(sNum, aNum); }
												                                        else { helper.showTafseerDialog(sNum, aNum); }
												                                    } else {
												                                        if(isTestMode[0]) {
													                                            int currentMax = testRevealedUpToAyah.containsKey(sNum) ? testRevealedUpToAyah.get(sNum) : 0;
													                                            if (aNum > currentMax) { testRevealedUpToAyah.put(sNum, aNum); vp.getAdapter().notifyDataSetChanged(); }
													                                            else { toggleMenus.run(); }
													                                        } else { toggleMenus.run(); }
												                                    }
											                                    return;
											                                }
										                            }
									                        }
								                        if(!isLongPress) toggleMenus.run();
								                    } catch (Exception ex) {}
							                }
						            });
					            @Override public boolean onTouch(android.view.View v, android.view.MotionEvent event) {
						                gd.onTouchEvent(event);
						                return true;
						            }
					        });
				
				        android.widget.RelativeLayout.LayoutParams pContent = new android.widget.RelativeLayout.LayoutParams(-1, -1);
				        pContent.addRule(android.widget.RelativeLayout.BELOW, headerLayout.getId());
				        pContent.addRule(android.widget.RelativeLayout.ABOVE, txtPageNum.getId());
				        pContent.setMargins(10, 5, 10, 5);
				        pageContainer.addView(headerLayout); pageContainer.addView(content, pContent); pageContainer.addView(txtPageNum);
				        c.addView(pageContainer); return pageContainer;
				    }
			    @Override public void destroyItem(android.view.ViewGroup c, int p, Object o) { c.removeView((android.view.View)o); }
		});
		
		// أحداث الأزرار
		btnBookmarks.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) { startActivity(new android.content.Intent(ReadingActivity.this, BookmarksActivity.class)); }
		});
		btnTheme.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        currentIsDarkMode[0] = !currentIsDarkMode[0];
				        prefs.edit().putBoolean("dark_mode", currentIsDarkMode[0]).apply();
				        try{btnTheme.setImageResource(currentIsDarkMode[0] ? R.drawable.ic_moon : R.drawable.ic_sun);}catch(Exception e){}
				        rootFrame.setBackgroundColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#121212") : customBgColor[0]);
				        vp.getAdapter().notifyDataSetChanged(); verticalPagesContainer.removeAllViews();
				    }
		});
		btnSearch.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) { helper.showSearchDialog(); }
		});
		
		btnSettings.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        android.widget.ScrollView scrollView = new android.widget.ScrollView(ReadingActivity.this);
				        android.widget.LinearLayout rootLayout = new android.widget.LinearLayout(ReadingActivity.this);
				        rootLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
				        rootLayout.setPadding(40, 60, 40, 60);
				
				        android.graphics.drawable.GradientDrawable rootGd = new android.graphics.drawable.GradientDrawable();
				        rootGd.setColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#1E1E1E") : android.graphics.Color.parseColor("#F5F7F8"));
				        rootGd.setCornerRadius(60f);
				        rootLayout.setBackground(rootGd);
				
				        android.widget.TextView titleText = new android.widget.TextView(ReadingActivity.this);
				        titleText.setText(useEnglishLanguage[0] ? "Reading Settings" : "إعدادات القراءة");
				        titleText.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.parseColor("#00695C"));
				        titleText.setTextSize(22);
				        titleText.setTypeface(android.graphics.Typeface.create("sans-serif-medium", android.graphics.Typeface.BOLD));
				        titleText.setGravity(android.view.Gravity.CENTER);
				        titleText.setPadding(0, 0, 0, 40);
				        rootLayout.addView(titleText);
				
				        android.graphics.drawable.GradientDrawable cardBackground = new android.graphics.drawable.GradientDrawable();
				        cardBackground.setColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE);
				        cardBackground.setCornerRadius(40f);
				        android.widget.LinearLayout.LayoutParams cardParams = new android.widget.LinearLayout.LayoutParams(-1, -2);
				        cardParams.setMargins(0, 0, 0, 40);
				
				        android.widget.LinearLayout colorCard = new android.widget.LinearLayout(ReadingActivity.this);
				        colorCard.setOrientation(android.widget.LinearLayout.VERTICAL);
				        colorCard.setBackground(cardBackground);
				        colorCard.setPadding(40, 40, 40, 40);
				        if (android.os.Build.VERSION.SDK_INT >= 21) colorCard.setElevation(12f);
				        colorCard.setLayoutParams(cardParams);
				
				        android.widget.TextView bgLabel = new android.widget.TextView(ReadingActivity.this);
				        bgLabel.setText(useEnglishLanguage[0] ? "Mushaf Background" : "لون خلفية المصحف");
				        bgLabel.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.LTGRAY : android.graphics.Color.parseColor("#37474F"));
				        bgLabel.setTextSize(15);
				        bgLabel.setTypeface(null, android.graphics.Typeface.BOLD);
				        bgLabel.setGravity(android.view.Gravity.RIGHT);
				        bgLabel.setPadding(0, 0, 10, 30);
				        colorCard.addView(bgLabel);
				
				        android.widget.LinearLayout colorsLayout = new android.widget.LinearLayout(ReadingActivity.this);
				        colorsLayout.setOrientation(android.widget.LinearLayout.HORIZONTAL);
				        colorsLayout.setGravity(android.view.Gravity.CENTER);
				
				        final String[] hexColors = {"#FFFFFF", "#FDF6E3", "#E8F5E9", "#424242"};
				        final android.widget.Button[] colorBtns = new android.widget.Button[hexColors.length];
				
				        for (int i = 0; i < hexColors.length; i++) {
					            final String hexColor = hexColors[i];
					            final android.widget.Button colorBtn = new android.widget.Button(ReadingActivity.this);
					            android.widget.LinearLayout.LayoutParams colorParams = new android.widget.LinearLayout.LayoutParams(120, 120);
					            colorParams.setMargins(20, 0, 20, 0);
					            colorBtn.setLayoutParams(colorParams);
					
					            final android.graphics.drawable.GradientDrawable colorGd = new android.graphics.drawable.GradientDrawable();
					            colorGd.setShape(android.graphics.drawable.GradientDrawable.OVAL);
					            colorGd.setColor(android.graphics.Color.parseColor(hexColor));
					
					            if(i == 0) colorGd.setStroke(6, android.graphics.Color.parseColor("#00695C"));
					            else colorGd.setStroke(2, android.graphics.Color.parseColor("#CFD8DC"));
					
					            colorBtn.setBackground(colorGd);
					            colorBtns[i] = colorBtn;
					
					            colorBtn.setOnClickListener(new android.view.View.OnClickListener() {
						                @Override public void onClick(android.view.View v) {
							                    for(android.widget.Button btn : colorBtns) {
								                        ((android.graphics.drawable.GradientDrawable)btn.getBackground()).setStroke(2, android.graphics.Color.parseColor("#CFD8DC"));
								                    }
							                    ((android.graphics.drawable.GradientDrawable)v.getBackground()).setStroke(6, android.graphics.Color.parseColor("#00695C"));
							                    int selectedColor = android.graphics.Color.parseColor(hexColor);
							                    customBgColor[0] = selectedColor;
							                    prefs.edit().putInt("custom_bg", selectedColor).apply();
							                    if(!currentIsDarkMode[0]) rootFrame.setBackgroundColor(selectedColor);
							                }
						            });
					            colorsLayout.addView(colorBtn);
					        }
				        colorCard.addView(colorsLayout);
				        rootLayout.addView(colorCard);
				
				        android.widget.LinearLayout fontCard = new android.widget.LinearLayout(ReadingActivity.this);
				        fontCard.setOrientation(android.widget.LinearLayout.VERTICAL);
				        fontCard.setBackground(cardBackground);
				        fontCard.setPadding(40, 40, 40, 40);
				        if (android.os.Build.VERSION.SDK_INT >= 21) fontCard.setElevation(12f);
				        fontCard.setLayoutParams(cardParams);
				
				        android.widget.TextView fontLabel = new android.widget.TextView(ReadingActivity.this);
				        fontLabel.setText(useEnglishLanguage[0] ? "Quran Font" : "الخط القرآني");
				        fontLabel.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.LTGRAY : android.graphics.Color.parseColor("#37474F"));
				        fontLabel.setTextSize(15);
				        fontLabel.setTypeface(null, android.graphics.Typeface.BOLD);
				        fontLabel.setGravity(android.view.Gravity.RIGHT);
				        fontLabel.setPadding(0, 0, 10, 20);
				        fontCard.addView(fontLabel);
				
				        android.widget.HorizontalScrollView hScrollView = new android.widget.HorizontalScrollView(ReadingActivity.this);
				        hScrollView.setHorizontalScrollBarEnabled(false);
				        android.widget.LinearLayout fontsContainer = new android.widget.LinearLayout(ReadingActivity.this);
				        fontsContainer.setOrientation(android.widget.LinearLayout.HORIZONTAL);
				        fontsContainer.setGravity(android.view.Gravity.RIGHT);
				
				        final String[] fontPaths = {"fonts/add.ttf", "fonts/quran.ttf", "fonts/qran.ttf", "fonts/uthmani.ttf"};
				        final android.widget.TextView[] fontSamples = new android.widget.TextView[fontPaths.length];
				        for (int i = 0; i < fontPaths.length; i++) {
					            final android.widget.TextView fontSample = new android.widget.TextView(ReadingActivity.this);
					            fontSample.setText("الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ");
					            fontSample.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.parseColor("#546E7A"));
					            fontSample.setTextSize(20);
					            fontSample.setPadding(50, 30, 50, 30);
					
					            final android.graphics.drawable.GradientDrawable fontGd = new android.graphics.drawable.GradientDrawable();
					            fontGd.setColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#333333") : android.graphics.Color.parseColor("#F5F7F8"));
					            fontGd.setCornerRadius(25f);
					
					            if(i == 0) {
						                fontGd.setStroke(4, android.graphics.Color.parseColor("#00695C"));
						                fontSample.setTextColor(android.graphics.Color.parseColor("#00695C"));
						            } else {
						                fontGd.setStroke(2, android.graphics.Color.TRANSPARENT);
						            }
					
					            fontSample.setBackground(fontGd);
					            android.widget.LinearLayout.LayoutParams fParams = new android.widget.LinearLayout.LayoutParams(-2, -2);
					            fParams.setMargins(15, 10, 15, 20);
					            fontSample.setLayoutParams(fParams);
					
					            fontSamples[i] = fontSample;
					            final int finalI = i;
					            fontSample.setOnClickListener(new android.view.View.OnClickListener() {
						                @Override public void onClick(android.view.View v) {
							                    for(android.widget.TextView txt : fontSamples) {
								                        ((android.graphics.drawable.GradientDrawable)txt.getBackground()).setStroke(2, android.graphics.Color.TRANSPARENT);
								                        txt.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.parseColor("#546E7A"));
								                    }
							                    ((android.graphics.drawable.GradientDrawable)v.getBackground()).setStroke(4, android.graphics.Color.parseColor("#00695C"));
							                    ((android.widget.TextView)v).setTextColor(android.graphics.Color.parseColor("#00695C"));
							                    currentFontPath[0] = fontPaths[finalI];
							                    try { quranFont[0] = android.graphics.Typeface.createFromAsset(getAssets(), fontPaths[finalI]); } catch(Exception e){}
							                    prefs.edit().putString("font_path", fontPaths[finalI]).apply();
							                    vp.getAdapter().notifyDataSetChanged();
							                }
						            });
					            fontsContainer.addView(fontSample);
					        }
				        hScrollView.addView(fontsContainer);
				        fontCard.addView(hScrollView);
				        rootLayout.addView(fontCard);
				
				        android.widget.LinearLayout settingsCard = new android.widget.LinearLayout(ReadingActivity.this);
				        settingsCard.setOrientation(android.widget.LinearLayout.VERTICAL);
				        settingsCard.setBackground(cardBackground);
				        settingsCard.setPadding(40, 40, 40, 40);
				        if (android.os.Build.VERSION.SDK_INT >= 21) settingsCard.setElevation(12f);
				        settingsCard.setLayoutParams(cardParams);
				
				        android.widget.LinearLayout buttonsLayout = new android.widget.LinearLayout(ReadingActivity.this);
				        buttonsLayout.setOrientation(android.widget.LinearLayout.HORIZONTAL);
				        buttonsLayout.setWeightSum(2f);
				        android.widget.LinearLayout.LayoutParams btnParams = new android.widget.LinearLayout.LayoutParams(0, -2, 1f);
				        btnParams.setMargins(10, 0, 10, 40);
				
				        final android.widget.Button btnEng = new android.widget.Button(ReadingActivity.this);
				        btnEng.setText(useEnglishNumbers[0] ? (useEnglishLanguage[0] ? "English: ON" : "الإنجليزية: مفعل") : (useEnglishLanguage[0] ? "English: OFF" : "الإنجليزية: معطل"));
				        btnEng.setTextColor(android.graphics.Color.WHITE);
				        btnEng.setTextSize(13);
				        android.graphics.drawable.GradientDrawable btnGd1 = new android.graphics.drawable.GradientDrawable();
				        btnGd1.setColor(android.graphics.Color.parseColor("#00695C"));
				        btnGd1.setCornerRadius(30f);
				        btnEng.setBackground(btnGd1);
				        btnEng.setLayoutParams(btnParams);
				        btnEng.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                useEnglishNumbers[0] = !useEnglishNumbers[0];
						                prefs.edit().putBoolean("eng_nums", useEnglishNumbers[0]).apply();
						                vp.getAdapter().notifyDataSetChanged();
						                btnEng.setText(useEnglishNumbers[0] ? (useEnglishLanguage[0] ? "English: ON" : "الإنجليزية: مفعل") : (useEnglishLanguage[0] ? "English: OFF" : "الإنجليزية: معطل"));
						            }
					        });
				
				        final android.widget.Button btnDecor = new android.widget.Button(ReadingActivity.this);
				        btnDecor.setText(useEnglishLanguage[0] ? "Ornament" : "شكل الزخرفة");
				        btnDecor.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.BLACK : android.graphics.Color.parseColor("#37474F"));
				        btnDecor.setTextSize(13);
				        android.graphics.drawable.GradientDrawable btnGd2 = new android.graphics.drawable.GradientDrawable();
				        btnGd2.setColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#555555") : android.graphics.Color.parseColor("#ECEFF1"));
				        btnGd2.setCornerRadius(30f);
				        btnDecor.setBackground(btnGd2);
				        btnDecor.setLayoutParams(btnParams);
				        btnDecor.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                numberShapeStyle[0] = (numberShapeStyle[0] + 1) % 3;
						                prefs.edit().putInt("num_shape", numberShapeStyle[0]).apply();
						                vp.getAdapter().notifyDataSetChanged();
						            }
					        });
				
				        buttonsLayout.addView(btnEng);
				        buttonsLayout.addView(btnDecor);
				        settingsCard.addView(buttonsLayout);
				
				        String[] switchTexts = useEnglishLanguage[0] ? 
				            new String[]{"Auto-play (Long press)", "English Language"} : 
				            new String[]{"التشغيل التلقائي (ضغط مطول)", "تفعيل اللغة الإنجليزية"};
				        final android.widget.Switch[] switches = new android.widget.Switch[2];
				        for(int i = 0; i < switchTexts.length; i++) {
					            android.widget.LinearLayout row = new android.widget.LinearLayout(ReadingActivity.this);
					            row.setOrientation(android.widget.LinearLayout.HORIZONTAL);
					            row.setGravity(android.view.Gravity.CENTER_VERTICAL);
					            row.setPadding(0, 20, 0, 20);
					
					            android.widget.Switch sw = new android.widget.Switch(ReadingActivity.this);
					            sw.setThumbTintList(android.content.res.ColorStateList.valueOf(android.graphics.Color.parseColor("#00695C")));
					            sw.setTrackTintList(android.content.res.ColorStateList.valueOf(android.graphics.Color.parseColor("#B2DFDB")));
					            switches[i] = sw;
					
					            android.widget.TextView tv = new android.widget.TextView(ReadingActivity.this);
					            tv.setText(switchTexts[i]);
					            tv.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.LTGRAY : android.graphics.Color.parseColor("#455A64"));
					            tv.setTextSize(14);
					            tv.setGravity(android.view.Gravity.RIGHT);
					            android.widget.LinearLayout.LayoutParams tvParams = new android.widget.LinearLayout.LayoutParams(0, -2, 1f);
					            tv.setLayoutParams(tvParams);
					
					            row.addView(sw);
					            row.addView(tv);
					            settingsCard.addView(row);
					        }
				        switches[0].setOnCheckedChangeListener(null);
				        switches[1].setOnCheckedChangeListener(null);
				        switches[0].setChecked(autoPlayOnLongPress[0]);
				        switches[1].setChecked(useEnglishLanguage[0]);
				        switches[0].setOnCheckedChangeListener(new android.widget.CompoundButton.OnCheckedChangeListener() {
					            @Override public void onCheckedChanged(android.widget.CompoundButton buttonView, boolean isChecked) {
						                autoPlayOnLongPress[0] = isChecked;
						                prefs.edit().putBoolean("auto_play_long", isChecked).apply();
						            }
					        });
				        switches[1].setOnCheckedChangeListener(new android.widget.CompoundButton.OnCheckedChangeListener() {
					            @Override public void onCheckedChanged(android.widget.CompoundButton buttonView, boolean isChecked) {
						                useEnglishLanguage[0] = isChecked;
						                prefs.edit().putBoolean("use_english", isChecked).apply();
						                vp.getAdapter().notifyDataSetChanged();
						                android.widget.Toast.makeText(ReadingActivity.this, isChecked ? "Language: English" : "اللغة: العربية", android.widget.Toast.LENGTH_SHORT).show();
						            }
					        });
				
				        android.view.View divider = new android.view.View(ReadingActivity.this);
				        divider.setLayoutParams(new android.widget.LinearLayout.LayoutParams(-1, 2));
				        divider.setBackgroundColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#555555") : android.graphics.Color.parseColor("#ECEFF1"));
				        ((android.widget.LinearLayout.LayoutParams) divider.getLayoutParams()).setMargins(0, 20, 0, 20);
				        settingsCard.addView(divider);
				
				        android.widget.LinearLayout spinnerRow = new android.widget.LinearLayout(ReadingActivity.this);
				        spinnerRow.setOrientation(android.widget.LinearLayout.HORIZONTAL);
				        spinnerRow.setGravity(android.view.Gravity.CENTER_VERTICAL);
				        spinnerRow.setPadding(0, 10, 0, 10);
				
				        final android.widget.Spinner viewSpinner = new android.widget.Spinner(ReadingActivity.this);
				        String[] viewOptions = useEnglishLanguage[0] ? 
				            new String[]{"Page number only", "Page + Ayah", "Page + Ayah + Surah"} : 
				            new String[]{"رقم الصفحة فقط", "الصفحة + الآية", "الصفحة + الآية + السورة"};
				        android.widget.ArrayAdapter<String> spinnerAdapter = new android.widget.ArrayAdapter<>(ReadingActivity.this, android.R.layout.simple_spinner_item, viewOptions);
				        spinnerAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
				        viewSpinner.setAdapter(spinnerAdapter);
				        int safeSelection = Math.min(seekbarDisplayMode[0], viewOptions.length - 1);
				        viewSpinner.setSelection(safeSelection);
				        viewSpinner.setOnItemSelectedListener(new android.widget.AdapterView.OnItemSelectedListener() {
					            @Override public void onItemSelected(android.widget.AdapterView<?> parent, android.view.View view, int position, long id) {
						                seekbarDisplayMode[0] = position;
						                prefs.edit().putInt("seekbar_display_mode", position).apply();
						            }
					            @Override public void onNothingSelected(android.widget.AdapterView<?> parent) {}
					        });
				
				        android.widget.TextView spinnerTv = new android.widget.TextView(ReadingActivity.this);
				        spinnerTv.setText(useEnglishLanguage[0] ? "Seekbar Display" : "عرض شريط التمرير");
				        spinnerTv.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.LTGRAY : android.graphics.Color.parseColor("#455A64"));
				        spinnerTv.setTextSize(14);
				        spinnerTv.setGravity(android.view.Gravity.RIGHT);
				        android.widget.LinearLayout.LayoutParams spTvParams = new android.widget.LinearLayout.LayoutParams(0, -2, 1f);
				        spinnerTv.setLayoutParams(spTvParams);
				
				        spinnerRow.addView(viewSpinner);
				        spinnerRow.addView(spinnerTv);
				        settingsCard.addView(spinnerRow);
				
				        rootLayout.addView(settingsCard);
				        scrollView.addView(rootLayout);
				        android.app.AlertDialog.Builder builder = new android.app.AlertDialog.Builder(ReadingActivity.this);
				        builder.setView(scrollView);
				        final android.app.AlertDialog dialog = builder.create();
				
				        if (dialog.getWindow() != null) {
					            dialog.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.TRANSPARENT));
					            dialog.getWindow().getAttributes().windowAnimations = android.R.style.Animation_Dialog;
					        }
				        dialog.show();
				    }
		});
		
		jumpSeekBar.setOnSeekBarChangeListener(new android.widget.SeekBar.OnSeekBarChangeListener() {
			    @Override public void onProgressChanged(android.widget.SeekBar seekBar, int progress, boolean fromUser) {
				        if (!fromUser) return;
				        int pageN = sortedPages.get(progress);
				        String surahName = pageSurahMap.get(pageN);
				        int firstAyah = 1;
				        try { for (java.util.Map.Entry<String, Integer> e : ayahPageMap.entrySet()) if (e.getValue() == pageN) { firstAyah = Integer.parseInt(e.getKey().split(":")[1]); break; } } catch (Exception ex) {}
				        String displayText = "";
				        switch (seekbarDisplayMode[0]) {
					            case 0: displayText = (useEnglishLanguage[0] ? "Page " : "صفحة ") + pageN; break;
					            case 1: displayText = (useEnglishLanguage[0] ? "Page " : "صفحة ") + pageN + " | " + (useEnglishLanguage[0] ? "Ayah " : "آية ") + firstAyah; break;
					            case 2: displayText = surahName + " | " + (useEnglishLanguage[0] ? "Ayah " : "آية ") + firstAyah + " | " + (useEnglishLanguage[0] ? "Page " : "صفحة ") + pageN; break;
					        }
				        floatingBadge.setText(displayText);
				        floatingBadge.setVisibility(android.view.View.VISIBLE);
				        final android.widget.SeekBar fs = seekBar;
				        fs.post(new Runnable() {
					            @Override public void run() {
						                int[] seekBarLocation = new int[2];
						                int[] containerLocation = new int[2];
						                fs.getLocationInWindow(seekBarLocation);
						                bottomMasterContainer.getLocationInWindow(containerLocation);
						                int thumbX = seekBarLocation[0] + fs.getThumb().getBounds().centerX() - containerLocation[0];
						                int thumbY = seekBarLocation[1] - containerLocation[1];
						                floatingBadge.setX(thumbX - floatingBadge.getWidth() / 2f);
						                floatingBadge.setY(thumbY - floatingBadge.getHeight() - 10);
						            }
					        });
				    }
			    @Override public void onStartTrackingTouch(android.widget.SeekBar seekBar) { floatingBadge.setVisibility(android.view.View.VISIBLE); onProgressChanged(seekBar, seekBar.getProgress(), true); }
			    @Override public void onStopTrackingTouch(android.widget.SeekBar seekBar) { floatingBadge.setVisibility(android.view.View.GONE); vp.setCurrentItem(seekBar.getProgress(), false); }
		});
		
		btnHifz.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        isTestMode[0] = !isTestMode[0]; testRevealedUpToAyah.clear();
				        vp.getAdapter().notifyDataSetChanged(); verticalPagesContainer.removeAllViews();
				        android.widget.Toast.makeText(getApplicationContext(), isTestMode[0] ? "تم تفعيل وضع الحفظ" : "تم الإلغاء", 0).show();
				    }
		});
		
		btnPlay.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        playSingleAyahOnly[0] = false;
				        int currentP = sortedPages.get(vp.getCurrentItem());
				        String rawText = pageTextsMap.get(currentP);
				        int startS = 1, startA = 1;
				        if (rawText != null) {
					            int startTag = rawText.indexOf("[@]");
					            int endTag = rawText.indexOf("[@]", startTag + 3);
					            if (startTag != -1 && endTag != -1) {
						                String meta = rawText.substring(startTag + 3, endTag).trim();
						                try { String[] parts = meta.split(":"); startS = Integer.parseInt(parts[0]); startA = Integer.parseInt(parts[1]); } catch(Exception e){}
						            }
					        }
				        helper.playAudio(startS, startA);
				    }
		});
		btnAudioStop.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        if(quranPlayer[0]!=null){ quranPlayer[0].stop(); quranPlayer[0].release(); quranPlayer[0]=null; }
				        audioProgressHandler.removeCallbacks(audioProgressRunnable[0]);
				        currentAudioSurah[0]=0; currentAudioAyah[0]=0;
				        audioPlayerLayout.setVisibility(android.view.View.GONE);
				        vp.getAdapter().notifyDataSetChanged();
				    }
		});
		btnAudioPlayPause.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        if(quranPlayer[0]!=null && quranPlayer[0].isPlaying()){ quranPlayer[0].pause(); btnAudioPlayPause.setText("▶"); }
				        else if(quranPlayer[0]!=null){ quranPlayer[0].start(); btnAudioPlayPause.setText("⏸"); }
				    }
		});
		btnAudioSpeed.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        float speed = prefs.getFloat("speed_val",1.0f);
				        if(speed==1.0f) speed=1.5f; else if(speed==1.5f) speed=2.0f; else if(speed==2.0f) speed=0.5f; else speed=1.0f;
				        prefs.edit().putFloat("speed_val",speed).apply(); btnAudioSpeed.setText(speed+"x");
				        if(quranPlayer[0]!=null && android.os.Build.VERSION.SDK_INT>=23) quranPlayer[0].setPlaybackParams(quranPlayer[0].getPlaybackParams().setSpeed(speed));
				    }
		});
		btnAudioNext.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        currentRepeatCount[0]=0;
				        if(currentAudioAyah[0] < totalAyahsPerSurah[currentAudioSurah[0]]) helper.playAudio(currentAudioSurah[0], currentAudioAyah[0]+1);
				        else if(currentAudioSurah[0]<114) helper.playAudio(currentAudioSurah[0]+1, 1);
				    }
		});
		btnAudioPrev.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        currentRepeatCount[0]=0;
				        if(currentAudioAyah[0]>1) helper.playAudio(currentAudioSurah[0], currentAudioAyah[0]-1);
				        else if(currentAudioSurah[0]>1) helper.playAudio(currentAudioSurah[0]-1, 1);
				    }
		});
		btnAudioRepeat.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        currentRepeatMode[0] = (currentRepeatMode[0] + 1) % 4;
				        currentRepeatCount[0] = 0;
				        String[] labels = {"🔁 1x", "🔁 2x", "🔁 3x", "🔁 ∞"};
				        btnAudioRepeat.setText(labels[currentRepeatMode[0]]);
				        if (currentRepeatMode[0] == 3) btnAudioRepeat.setTextColor(android.graphics.Color.parseColor("#FFC107"));
				        else btnAudioRepeat.setTextColor(android.graphics.Color.parseColor("#C8E6C9"));
				    }
		});
		
		btnReciter.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) { btnAudioDownload.performClick(); }
		});
		
		btnAudioDownload.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        android.widget.ScrollView scrollView = new android.widget.ScrollView(ReadingActivity.this);
				        android.widget.LinearLayout rootLayout = new android.widget.LinearLayout(ReadingActivity.this);
				        rootLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
				        rootLayout.setPadding(50, 50, 50, 50);
				
				        android.graphics.drawable.GradientDrawable gd = new android.graphics.drawable.GradientDrawable();
				        gd.setColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#1A1A24") : android.graphics.Color.parseColor("#F5F7F8"));
				        gd.setCornerRadius(40f);
				        rootLayout.setBackground(gd);
				
				        final android.widget.TextView reciterLabel = new android.widget.TextView(ReadingActivity.this);
				        reciterLabel.setText(useEnglishLanguage[0] ? "Select Reciter for Download:" : "اختر القارئ للتحميل:");
				        reciterLabel.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.BLACK);
				        reciterLabel.setPadding(0, 0, 0, 15);
				        rootLayout.addView(reciterLabel);
				
				        final android.widget.Spinner reciterSpinner = new android.widget.Spinner(ReadingActivity.this);
				        android.widget.ArrayAdapter<String> reciterAdapter = new android.widget.ArrayAdapter<>(ReadingActivity.this, android.R.layout.simple_spinner_item, readersDisplay.toArray(new String[0]));
				        reciterSpinner.setAdapter(reciterAdapter);
				        rootLayout.addView(reciterSpinner);
				
				        android.widget.LinearLayout statsLayout = new android.widget.LinearLayout(ReadingActivity.this);
				        statsLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
				        statsLayout.setPadding(20, 20, 20, 20);
				        android.graphics.drawable.GradientDrawable statsGd = new android.graphics.drawable.GradientDrawable();
				        statsGd.setColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#2A2A36") : android.graphics.Color.parseColor("#E8F0FE"));
				        statsGd.setCornerRadius(20f);
				        statsLayout.setBackground(statsGd);
				        android.widget.LinearLayout.LayoutParams statsParams = new android.widget.LinearLayout.LayoutParams(-1, -2);
				        statsParams.setMargins(0, 30, 0, 30);
				        statsLayout.setLayoutParams(statsParams);
				
				        final android.widget.TextView statsText = new android.widget.TextView(ReadingActivity.this);
				        statsText.setTextColor(android.graphics.Color.parseColor("#00D28A"));
				        statsText.setGravity(android.view.Gravity.CENTER);
				        statsText.setSingleLine(false);
				        statsText.setEllipsize(null);
				        statsLayout.addView(statsText);
				        rootLayout.addView(statsLayout);
				
				        final android.widget.ToggleButton btnFull = new android.widget.ToggleButton(ReadingActivity.this);
				        btnFull.setText(useEnglishLanguage[0] ? "Full Quran" : "القرآن كاملاً");
				        btnFull.setTextOn(useEnglishLanguage[0] ? "Full Quran" : "القرآن كاملاً");
				        btnFull.setTextOff(useEnglishLanguage[0] ? "Full Quran" : "القرآن كاملاً");
				        btnFull.setChecked(true);
				        final android.widget.ToggleButton btnSingle = new android.widget.ToggleButton(ReadingActivity.this);
				        btnSingle.setText(useEnglishLanguage[0] ? "Single Surah" : "سورة محددة");
				        btnSingle.setTextOn(useEnglishLanguage[0] ? "Single Surah" : "سورة محددة");
				        btnSingle.setTextOff(useEnglishLanguage[0] ? "Single Surah" : "سورة محددة");
				        btnSingle.setChecked(false);
				
				        android.widget.LinearLayout toggleRow = new android.widget.LinearLayout(ReadingActivity.this);
				        toggleRow.setOrientation(android.widget.LinearLayout.HORIZONTAL);
				        toggleRow.setGravity(android.view.Gravity.CENTER);
				        toggleRow.addView(btnFull);
				        toggleRow.addView(btnSingle);
				        rootLayout.addView(toggleRow);
				
				        final android.widget.LinearLayout surahLayout = new android.widget.LinearLayout(ReadingActivity.this);
				        surahLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
				        surahLayout.setVisibility(android.view.View.GONE);
				
				        android.widget.TextView surahLabel = new android.widget.TextView(ReadingActivity.this);
				        surahLabel.setText(useEnglishLanguage[0] ? "Select Surah:" : "اختر السورة:");
				        surahLabel.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.BLACK);
				        surahLabel.setPadding(0, 15, 0, 15);
				        surahLayout.addView(surahLabel);
				
				        final android.widget.Spinner surahSpinner = new android.widget.Spinner(ReadingActivity.this);
				        android.widget.ArrayAdapter<String> surahAdapter = new android.widget.ArrayAdapter<>(ReadingActivity.this, android.R.layout.simple_spinner_item, surahNamesList.toArray(new String[0]));
				        surahSpinner.setAdapter(surahAdapter);
				        surahLayout.addView(surahSpinner);
				        rootLayout.addView(surahLayout);
				
				        btnFull.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                btnFull.setChecked(true);
						                btnSingle.setChecked(false);
						                surahLayout.setVisibility(android.view.View.GONE);
						            }
					        });
				        btnSingle.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                btnSingle.setChecked(true);
						                btnFull.setChecked(false);
						                surahLayout.setVisibility(android.view.View.VISIBLE);
						            }
					        });
				
				        reciterSpinner.setOnItemSelectedListener(new android.widget.AdapterView.OnItemSelectedListener() {
					            @Override public void onItemSelected(android.widget.AdapterView<?> parent, android.view.View view, int position, long id) {
						                String readerFolder = readersFolders.get(position);
						                java.io.File audioDir = new java.io.File(getExternalFilesDir(null), "quran_audio/" + readerFolder);
						                int downloaded = 0;
						                if (audioDir.exists()) {
							                    for (int s = 1; s <= 114; s++) {
								                        java.io.File firstAyah = new java.io.File(audioDir, String.format(java.util.Locale.US, "%03d001.mp3", s));
								                        if (firstAyah.exists()) downloaded++;
								                    }
							                }
						                statsText.setText((useEnglishLanguage[0] ? "Downloaded: " : "السور المحملة: ") + downloaded + " / 114");
						            }
					            @Override public void onNothingSelected(android.widget.AdapterView<?> parent) {}
					        });
				        reciterSpinner.setSelection(0);
				
				        android.widget.TextView percentText = new android.widget.TextView(ReadingActivity.this);
				        percentText.setText("0%");
				        percentText.setTextColor(android.graphics.Color.parseColor("#00D28A"));
				        percentText.setTextSize(28);
				        percentText.setTypeface(null, android.graphics.Typeface.BOLD);
				        percentText.setGravity(android.view.Gravity.CENTER);
				        percentText.setPadding(0, 40, 0, 10);
				        rootLayout.addView(percentText);
				
				        final android.widget.ProgressBar progressBar = new android.widget.ProgressBar(ReadingActivity.this, null, android.R.attr.progressBarStyleHorizontal);
				        progressBar.setMax(100);
				        progressBar.setProgress(0);
				        progressBar.setProgressTintList(android.content.res.ColorStateList.valueOf(android.graphics.Color.parseColor("#00D28A")));
				        rootLayout.addView(progressBar);
				
				        final android.widget.TextView detailsText = new android.widget.TextView(ReadingActivity.this);
				        detailsText.setText(useEnglishLanguage[0] ? "Waiting to start..." : "في انتظار بدء التحميل...");
				        detailsText.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.parseColor("#B2BEC3") : android.graphics.Color.DKGRAY);
				        detailsText.setTextSize(12);
				        detailsText.setGravity(android.view.Gravity.CENTER);
				        detailsText.setPadding(0, 15, 0, 40);
				        rootLayout.addView(detailsText);
				
				        android.widget.LinearLayout buttonsLayout = new android.widget.LinearLayout(ReadingActivity.this);
				        buttonsLayout.setOrientation(android.widget.LinearLayout.HORIZONTAL);
				        buttonsLayout.setGravity(android.view.Gravity.CENTER);
				
				        android.widget.LinearLayout.LayoutParams btnParams = new android.widget.LinearLayout.LayoutParams(0, -2, 1.0f);
				        btnParams.setMargins(10, 0, 10, 0);
				
				        android.widget.Button btnStart = new android.widget.Button(ReadingActivity.this);
				        btnStart.setText(useEnglishLanguage[0] ? "Start" : "بدء");
				        btnStart.setTextColor(android.graphics.Color.WHITE);
				        android.graphics.drawable.GradientDrawable btnStartGd = new android.graphics.drawable.GradientDrawable();
				        btnStartGd.setColor(android.graphics.Color.parseColor("#457B9D"));
				        btnStartGd.setCornerRadius(20f);
				        btnStart.setBackground(btnStartGd);
				        btnStart.setLayoutParams(btnParams);
				        buttonsLayout.addView(btnStart);
				
				        android.widget.Button btnCancel = new android.widget.Button(ReadingActivity.this);
				        btnCancel.setText(useEnglishLanguage[0] ? "Close" : "إغلاق");
				        btnCancel.setTextColor(android.graphics.Color.WHITE);
				        android.graphics.drawable.GradientDrawable btnCancelGd = new android.graphics.drawable.GradientDrawable();
				        btnCancelGd.setColor(android.graphics.Color.parseColor("#E63946"));
				        btnCancelGd.setCornerRadius(20f);
				        btnCancel.setBackground(btnCancelGd);
				        btnCancel.setLayoutParams(btnParams);
				        buttonsLayout.addView(btnCancel);
				
				        rootLayout.addView(buttonsLayout);
				        scrollView.addView(rootLayout);
				
				        android.app.AlertDialog.Builder builder = new android.app.AlertDialog.Builder(ReadingActivity.this);
				        builder.setView(scrollView);
				        final android.app.AlertDialog dialog = builder.create();
				        if (dialog.getWindow() != null) {
					            dialog.getWindow().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.TRANSPARENT));
					        }
				        dialog.show();
				
				        btnCancel.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) { dialog.dismiss(); }
					        });
				
				        btnStart.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                final boolean isFull = btnFull.isChecked();
						                int readerIdx = reciterSpinner.getSelectedItemPosition();
						                final String readerFolder = readersFolders.get(readerIdx);
						                final String readerName = readersDisplay.get(readerIdx);
						                detailsText.setText(useEnglishLanguage[0] ? "Connecting to server..." : "جاري الاتصال بخادم التحميل...");
						                
						                if (isFull) {
							                    final android.app.ProgressDialog pd = new android.app.ProgressDialog(ReadingActivity.this);
							                    pd.setTitle((useEnglishLanguage[0] ? "Downloading Full Quran - " : "تحميل القرآن كاملاً - ") + readerName);
							                    pd.setMessage(useEnglishLanguage[0] ? "Preparing..." : "جاري التحضير...");
							                    pd.setProgressStyle(android.app.ProgressDialog.STYLE_HORIZONTAL);
							                    int total = 0; for(int s=1; s<=114; s++) total += totalAyahsPerSurah[s];
							                    pd.setMax(total);
							                    pd.setCancelable(true);
							                    pd.setButton(android.content.DialogInterface.BUTTON_NEGATIVE, useEnglishLanguage[0] ? "Cancel" : "إلغاء", new android.content.DialogInterface.OnClickListener() {
								                        @Override public void onClick(android.content.DialogInterface d, int w) { d.dismiss(); }
								                    });
							                    pd.show();
							                    new Thread(new Runnable() {
								                        @Override public void run() {
									                            try {
										                                java.io.File dir = new java.io.File(getExternalFilesDir(null), "quran_audio/"+readerFolder); if(!dir.exists()) dir.mkdirs();
										                                int prog = 0;
										                                for(int sura=1; sura<=114; sura++) {
											                                    for(int aya=1; aya<=totalAyahsPerSurah[sura]; aya++) {
												                                        String fileName = String.format(java.util.Locale.US, "%03d%03d.mp3", sura, aya);
												                                        final java.io.File outFile = new java.io.File(dir, fileName);
												                                        if(outFile.exists() && outFile.length()>5000) {
													                                            prog++; final int p=prog; final int s=sura, a=aya;
													                                            runOnUiThread(new Runnable() { @Override public void run() { pd.setProgress(p); pd.setMessage(surahNamesList.get(s-1)+" - "+(useEnglishLanguage[0]?"Ayah ":"آية ")+a+" ("+(useEnglishLanguage[0]?"cached":"موجودة")+")"); } });
													                                            continue;
													                                        }
												                                        java.net.URL url = new java.net.URL("https://everyayah.com/data/"+readerFolder+"/"+fileName);
												                                        java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
												                                        conn.setConnectTimeout(10000); conn.setReadTimeout(10000); conn.connect();
												                                        java.io.InputStream in = conn.getInputStream(); java.io.FileOutputStream out = new java.io.FileOutputStream(outFile);
												                                        byte[] buf = new byte[4096]; int len; while((len=in.read(buf))>0) out.write(buf,0,len);
												                                        out.close(); in.close(); conn.disconnect(); prog++;
												                                        final int p=prog; final int s=sura, a=aya;
												                                        runOnUiThread(new Runnable() { @Override public void run() { pd.setProgress(p); pd.setMessage((useEnglishLanguage[0]?"Downloading: ":"تحميل: ")+surahNamesList.get(s-1)+" - "+(useEnglishLanguage[0]?"Ayah ":"آية ")+a); } });
												                                    }
											                                }
										                                runOnUiThread(new Runnable() { @Override public void run() { pd.dismiss(); dialog.dismiss(); android.widget.Toast.makeText(ReadingActivity.this, (useEnglishLanguage[0]?"Full Quran downloaded with ":"اكتمل تحميل القرآن كاملاً بصوت ")+readerName, android.widget.Toast.LENGTH_LONG).show(); } });
										                            } catch(final Exception e) {
										                                runOnUiThread(new Runnable() { @Override public void run() { pd.dismiss(); android.widget.Toast.makeText(ReadingActivity.this, (useEnglishLanguage[0]?"Error: ":"خطأ: ")+e.getMessage(), android.widget.Toast.LENGTH_LONG).show(); } });
										                            }
									                        }
								                    }).start();
							                } else {
							                    final int suraToDL = surahSpinner.getSelectedItemPosition() + 1;
							                    final android.app.ProgressDialog pd = new android.app.ProgressDialog(ReadingActivity.this);
							                    pd.setTitle((useEnglishLanguage[0] ? "Downloading Surah " : "تحميل سورة ") + surahNamesList.get(suraToDL-1));
							                    pd.setMessage(useEnglishLanguage[0] ? "Preparing..." : "جاري التحضير...");
							                    pd.setProgressStyle(android.app.ProgressDialog.STYLE_HORIZONTAL);
							                    pd.setMax(totalAyahsPerSurah[suraToDL]);
							                    pd.setCancelable(true);
							                    pd.setButton(android.content.DialogInterface.BUTTON_NEGATIVE, useEnglishLanguage[0] ? "Cancel" : "إلغاء", new android.content.DialogInterface.OnClickListener() {
								                        @Override public void onClick(android.content.DialogInterface d, int w) { d.dismiss(); }
								                    });
							                    pd.show();
							                    new Thread(new Runnable() {
								                        @Override public void run() {
									                            try {
										                                java.io.File dir = new java.io.File(getExternalFilesDir(null), "quran_audio/"+readerFolder); if(!dir.exists()) dir.mkdirs();
										                                for(int aya=1; aya<=totalAyahsPerSurah[suraToDL]; aya++) {
											                                    String fileName = String.format(java.util.Locale.US, "%03d%03d.mp3", suraToDL, aya);
											                                    final java.io.File outFile = new java.io.File(dir, fileName);
											                                    if(outFile.exists() && outFile.length()>5000) {
												                                        final int prog = aya;
												                                        runOnUiThread(new Runnable() { @Override public void run() { pd.setProgress(prog); pd.setMessage((useEnglishLanguage[0]?"Ayah ":"الآية ")+prog+" ("+(useEnglishLanguage[0]?"cached":"موجودة")+")"); } });
												                                        continue;
												                                    }
											                                    java.net.URL url = new java.net.URL("https://everyayah.com/data/"+readerFolder+"/"+fileName);
											                                    java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
											                                    conn.setConnectTimeout(10000); conn.setReadTimeout(10000); conn.connect();
											                                    java.io.InputStream in = conn.getInputStream();
											                                    java.io.FileOutputStream out = new java.io.FileOutputStream(outFile);
											                                    byte[] buf = new byte[4096]; int len;
											                                    while((len=in.read(buf))>0) out.write(buf,0,len);
											                                    out.close(); in.close(); conn.disconnect();
											                                    final int prog = aya;
											                                    runOnUiThread(new Runnable() { @Override public void run() { pd.setProgress(prog); pd.setMessage((useEnglishLanguage[0]?"Downloaded Ayah ":"تم تحميل الآية ")+prog); } });
											                                }
										                                runOnUiThread(new Runnable() { @Override public void run() { pd.dismiss(); dialog.dismiss(); android.widget.Toast.makeText(ReadingActivity.this, (useEnglishLanguage[0]?"Surah ":"اكتمل تحميل سورة ")+surahNamesList.get(suraToDL-1), android.widget.Toast.LENGTH_SHORT).show(); } });
										                            } catch(final Exception e) {
										                                runOnUiThread(new Runnable() { @Override public void run() { pd.dismiss(); android.widget.Toast.makeText(ReadingActivity.this, (useEnglishLanguage[0]?"Error: ":"خطأ: ")+e.getMessage(), android.widget.Toast.LENGTH_LONG).show(); } });
										                            }
									                        }
								                    }).start();
							                }
						            }
					        });
				    }
		});
		
		verticalAutoScroll.setOnTouchListener(new android.view.View.OnTouchListener() {
			    android.view.GestureDetector gd = new android.view.GestureDetector(ReadingActivity.this, new android.view.GestureDetector.SimpleOnGestureListener() {
				        @Override public boolean onSingleTapConfirmed(android.view.MotionEvent e) {
					            if (autoScrollControl.getVisibility() == android.view.View.VISIBLE) {
						                autoScrollControl.setVisibility(android.view.View.GONE);
						                isAutoScrolling[0] = true;
						                scrollHandler.post(autoScrollRunnable);
						            } else {
						                autoScrollControl.setVisibility(android.view.View.VISIBLE);
						                isAutoScrolling[0] = false;
						                scrollHandler.removeCallbacks(autoScrollRunnable);
						            }
					            return true;
					        }
				    });
			    @Override public boolean onTouch(android.view.View v, android.view.MotionEvent event) { gd.onTouchEvent(event); return false; }
		});
		
		if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
			    verticalAutoScroll.setOnScrollChangeListener(new android.view.View.OnScrollChangeListener() {
				        @Override public void onScrollChange(android.view.View v, int scrollX, int scrollY, int oldScrollX, int oldScrollY) {
					            if (verticalPagesContainer.getChildCount() == 0) return;
					            android.view.View lastChild = verticalPagesContainer.getChildAt(verticalPagesContainer.getChildCount() - 1);
					            if (lastChild != null) {
						                int diff = (lastChild.getBottom() - (verticalAutoScroll.getHeight() + scrollY));
						                if (diff < 800 && lastLoadedAutoScrollPage[0] < sortedPages.size()) {
							                    int loadUntil = Math.min(lastLoadedAutoScrollPage[0] + 5, sortedPages.size());
							                    for (int i = lastLoadedAutoScrollPage[0]; i < loadUntil; i++) {
								                        int pNum = sortedPages.get(i);
								                        android.widget.TextView tv = new android.widget.TextView(ReadingActivity.this);
								                        tv.setTextSize(currentFontSize[0]); tv.setTypeface(quranFont[0]);
								                        tv.setLineSpacing(2f, 1.2f); tv.setGravity(android.view.Gravity.CENTER);
								                        tv.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.BLACK);
								                        tv.setPadding(20, 60, 20, 100); tv.setTextDirection(android.view.View.TEXT_DIRECTION_RTL);
								                        tv.setText(helper.getFormattedText(pNum));
								                        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O)
								                            tv.setJustificationMode(android.text.Layout.JUSTIFICATION_MODE_INTER_WORD);
								                        verticalPagesContainer.addView(tv);
								                    }
							                    lastLoadedAutoScrollPage[0] = loadUntil;
							                }
						            }
					        }
				    });
		}
		
		btnAutoScroll.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        vp.setVisibility(android.view.View.GONE); topBar.setVisibility(android.view.View.GONE);
				        bottomIconsLayout.setVisibility(android.view.View.GONE); seekContainer.setVisibility(android.view.View.GONE);
				        verticalAutoScroll.setVisibility(android.view.View.VISIBLE); autoScrollControl.setVisibility(android.view.View.VISIBLE);
				        verticalPagesContainer.removeAllViews();
				        int startP = vp.getCurrentItem(); currentAutoScrollStartPage[0] = startP;
				        lastLoadedAutoScrollPage[0] = Math.min(startP + 5, sortedPages.size());
				        for (int i = startP; i < lastLoadedAutoScrollPage[0]; i++) {
					            int pNum = sortedPages.get(i);
					            android.widget.TextView tv = new android.widget.TextView(ReadingActivity.this);
					            tv.setTextSize(currentFontSize[0]); tv.setTypeface(quranFont[0]);
					            tv.setLineSpacing(2f, 1.2f); tv.setGravity(android.view.Gravity.CENTER);
					            tv.setTextColor(currentIsDarkMode[0] ? android.graphics.Color.WHITE : android.graphics.Color.BLACK);
					            tv.setPadding(20, 60, 20, 100); tv.setTextDirection(android.view.View.TEXT_DIRECTION_RTL);
					            tv.setText(helper.getFormattedText(pNum));
					            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O)
					                tv.setJustificationMode(android.text.Layout.JUSTIFICATION_MODE_INTER_WORD);
					            verticalPagesContainer.addView(tv);
					        }
				        verticalAutoScroll.scrollTo(0, 0); isAutoScrolling[0] = false;
				    }
		});
		speedSeekBar.setOnSeekBarChangeListener(new android.widget.SeekBar.OnSeekBarChangeListener() {
			    @Override public void onProgressChanged(android.widget.SeekBar seekBar, int progress, boolean fromUser) { scrollSpeedDelay[0] = 105 - progress; }
			    @Override public void onStartTrackingTouch(android.widget.SeekBar seekBar) {}
			    @Override public void onStopTrackingTouch(android.widget.SeekBar seekBar) {}
		});
		btnCloseAutoText.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override public void onClick(android.view.View v) {
				        isAutoScrolling[0] = false; scrollHandler.removeCallbacks(autoScrollRunnable);
				        int scrollY = verticalAutoScroll.getScrollY(); int accumulatedHeight = 0; int targetChildIndex = 0;
				        for (int i = 0; i < verticalPagesContainer.getChildCount(); i++) {
					            android.view.View child = verticalPagesContainer.getChildAt(i); accumulatedHeight += child.getHeight();
					            if (scrollY < accumulatedHeight - (child.getHeight() / 3)) { targetChildIndex = i; break; }
					        }
				        int newVpIndex = currentAutoScrollStartPage[0] + targetChildIndex;
				        if (newVpIndex >= sortedPages.size()) newVpIndex = sortedPages.size() - 1;
				        vp.setCurrentItem(newVpIndex, false);
				        verticalAutoScroll.setVisibility(android.view.View.GONE); autoScrollControl.setVisibility(android.view.View.GONE);
				        vp.setVisibility(android.view.View.VISIBLE); bottomIconsLayout.setVisibility(android.view.View.VISIBLE);
				    }
		});
		
		int targetActualPage = -1;
		android.content.Intent intent = getIntent();
		if (intent.getBooleanExtra("continue_khatma", false)) {
			    int savedIndex = prefs.getInt("last_read_page_index", 0);
			    if(savedIndex >= 0 && savedIndex < sortedPages.size()) targetActualPage = sortedPages.get(savedIndex);
		} else if (intent.hasExtra("ayah_id") && intent.hasExtra("surah_id")) {
			    String key = intent.getStringExtra("surah_id") + ":" + intent.getStringExtra("ayah_id");
			    if(ayahPageMap.containsKey(key)) targetActualPage = ayahPageMap.get(key);
		} else if (intent.hasExtra("target_start_ayah") && intent.hasExtra("surah_id")) {
			    String key = intent.getStringExtra("surah_id") + ":" + intent.getIntExtra("target_start_ayah", 1);
			    if(ayahPageMap.containsKey(key)) targetActualPage = ayahPageMap.get(key);
		} else if (intent.hasExtra("surah_id")) {
			    int sId = Integer.parseInt(intent.getStringExtra("surah_id"));
			    if (sId <= surahStartPages.size() && sId > 0) targetActualPage = surahStartPages.get(sId - 1);
		}
		int jumpIndex = 0;
		if (targetActualPage != -1) { jumpIndex = sortedPages.indexOf(targetActualPage); if (jumpIndex == -1) jumpIndex = 0; }
		else jumpIndex = prefs.getInt("last_page", 0);
		final int finalJump = jumpIndex;
		vp.postDelayed(new Runnable() {
			    @Override public void run() { vp.setCurrentItem(finalJump, false); }
		}, 100);
		
		setContentView(rootFrame);
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