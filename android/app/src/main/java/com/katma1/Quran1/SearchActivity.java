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
import android.widget.CheckBox;
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

public class SearchActivity extends AppCompatActivity {
	
	private CheckBox checkbox1;
	private RadioButton radiobutton1;
	
	@Override
	protected void onCreate(Bundle _savedInstanceState) {
		super.onCreate(_savedInstanceState);
		setContentView(R.layout.search);
		initialize(_savedInstanceState);
		initializeLogic();
	}
	
	private void initialize(Bundle _savedInstanceState) {
		checkbox1 = findViewById(R.id.checkbox1);
		radiobutton1 = findViewById(R.id.radiobutton1);
	}
	
	private void initializeLogic() {
		// ==========================================================
		// 1. الإعدادات، الخطوط، والواجهة الغامرة (Immersive UI)
		// ==========================================================
		final android.content.SharedPreferences prefs = getSharedPreferences("QuranPrefs", android.content.Context.MODE_PRIVATE);
		final android.content.SharedPreferences searchHistoryPrefs = getSharedPreferences("search_history", android.content.Context.MODE_PRIVATE);
		final boolean isDarkMode = prefs.getBoolean("dark_mode", false);
		final android.graphics.Typeface quranFont = android.graphics.Typeface.createFromAsset(getAssets(), "fonts/add.ttf");
		
		getWindow().getDecorView().setSystemUiVisibility(
		    android.view.View.SYSTEM_UI_FLAG_LAYOUT_STABLE |
		    android.view.View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN |
		    android.view.View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
		);
		getWindow().setStatusBarColor(android.graphics.Color.TRANSPARENT);
		getWindow().setNavigationBarColor(android.graphics.Color.TRANSPARENT);
		
		android.widget.LinearLayout rootLayout = new android.widget.LinearLayout(this);
		rootLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
		rootLayout.setBackgroundColor(isDarkMode ? android.graphics.Color.parseColor("#121212") : android.graphics.Color.parseColor("#FDF9F1"));
		rootLayout.setLayoutParams(new android.view.ViewGroup.LayoutParams(-1, -1));
		rootLayout.setPadding(0, 80, 0, 120);
		
		// ==========================================================
		// 2. شريط البحث المتقدم (النصي والصوتي)
		// ==========================================================
		android.widget.LinearLayout searchBar = new android.widget.LinearLayout(this);
		searchBar.setOrientation(android.widget.LinearLayout.HORIZONTAL);
		searchBar.setPadding(30, 20, 30, 20);
		searchBar.setGravity(android.view.Gravity.CENTER_VERTICAL);
		
		final android.widget.ImageView btnVoiceSearch = new android.widget.ImageView(this);
		btnVoiceSearch.setImageResource(android.R.drawable.ic_btn_speak_now);
		btnVoiceSearch.setPadding(20, 20, 20, 20);
		btnVoiceSearch.setOnClickListener(new android.view.View.OnClickListener() {
			    @Override
			    public void onClick(android.view.View v) {
				        try {
					            android.content.Intent intent = new android.content.Intent(android.speech.RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
					            intent.putExtra(android.speech.RecognizerIntent.EXTRA_LANGUAGE_MODEL, android.speech.RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
					            intent.putExtra(android.speech.RecognizerIntent.EXTRA_LANGUAGE, "ar-SA");
					            startActivityForResult(intent, 1001);
					        } catch (Exception e) {
					            android.widget.Toast.makeText(SearchActivity.this, "البحث الصوتي غير مدعوم", android.widget.Toast.LENGTH_SHORT).show();
					        }
				    }
		});
		
		final android.widget.EditText inputSearch = new android.widget.EditText(this);
		android.widget.LinearLayout.LayoutParams inputParams = new android.widget.LinearLayout.LayoutParams(0, -2, 1f);
		inputParams.setMargins(15, 0, 0, 0);
		inputSearch.setLayoutParams(inputParams);
		inputSearch.setHint("ابحث نصياً أو صوتياً...");
		inputSearch.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.BLACK);
		inputSearch.setHintTextColor(android.graphics.Color.GRAY);
		android.graphics.drawable.GradientDrawable inputBg = new android.graphics.drawable.GradientDrawable();
		inputBg.setColor(isDarkMode ? android.graphics.Color.parseColor("#333333") : android.graphics.Color.parseColor("#F5F0E6"));
		inputBg.setCornerRadius(30f);
		inputSearch.setBackground(inputBg);
		inputSearch.setPadding(40, 35, 40, 35);
		inputSearch.setTextSize(18);
		inputSearch.setEnabled(false);
		
		searchBar.addView(btnVoiceSearch);
		searchBar.addView(inputSearch);
		rootLayout.addView(searchBar);
		
		// حاوية السجل
		final android.widget.HorizontalScrollView suggestionsScroll = new android.widget.HorizontalScrollView(this);
		suggestionsScroll.setHorizontalScrollBarEnabled(false);
		suggestionsScroll.setPadding(30, 0, 30, 10);
		final android.widget.LinearLayout suggestionsContainer = new android.widget.LinearLayout(this);
		suggestionsContainer.setOrientation(android.widget.LinearLayout.HORIZONTAL);
		suggestionsContainer.setLayoutDirection(android.view.View.LAYOUT_DIRECTION_RTL);
		suggestionsScroll.addView(suggestionsContainer);
		rootLayout.addView(suggestionsScroll);
		
		// شريط الإحصائيات والفلاتر
		android.widget.LinearLayout statsBar = new android.widget.LinearLayout(this);
		statsBar.setOrientation(android.widget.LinearLayout.HORIZONTAL);
		statsBar.setGravity(android.view.Gravity.CENTER_VERTICAL);
		statsBar.setPadding(30, 10, 30, 10);
		
		final android.widget.TextView tvStats = new android.widget.TextView(this);
		tvStats.setTextSize(14);
		tvStats.setTextColor(isDarkMode ? android.graphics.Color.LTGRAY : android.graphics.Color.DKGRAY);
		android.widget.LinearLayout.LayoutParams statsParams = new android.widget.LinearLayout.LayoutParams(0, -2, 1f);
		tvStats.setLayoutParams(statsParams);
		tvStats.setText("السور: 0, الآيات: 0");
		
		android.content.res.ColorStateList greenTint = new android.content.res.ColorStateList(
		    new int[][]{ new int[]{-android.R.attr.state_checked}, new int[]{android.R.attr.state_checked} },
		    new int[]{ isDarkMode ? android.graphics.Color.LTGRAY : android.graphics.Color.GRAY, android.graphics.Color.parseColor("#388E3C") }
		);
		final android.widget.CheckBox cbExactMatch = new android.widget.CheckBox(this);
		cbExactMatch.setText("مطابق");
		cbExactMatch.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.BLACK);
		cbExactMatch.setButtonTintList(greenTint);
		
		statsBar.addView(tvStats);
		statsBar.addView(cbExactMatch);
		rootLayout.addView(statsBar);
		
		final android.widget.TextView tvStatus = new android.widget.TextView(this);
		tvStatus.setText("جاري تهيئة محرك البحث الذكي... ⏳");
		tvStatus.setTextSize(16);
		tvStatus.setTextColor(android.graphics.Color.parseColor("#388E3C"));
		tvStatus.setGravity(android.view.Gravity.CENTER);
		tvStatus.setPadding(0, 20, 0, 20);
		rootLayout.addView(tvStatus);
		
		setContentView(rootLayout);
		
		// ==========================================================
		// 3. قارئ ملفات التفسير (قارئ XML ذكي)
		// ==========================================================
		abstract class TafsirHelper { abstract String getTafsirText(String fileName, int surah, int ayah); }
		final TafsirHelper tafsirHelper = new TafsirHelper() {
			    @Override
			    String getTafsirText(String fileName, int surah, int ayah) {
				        try {
					            java.io.InputStream is = getAssets().open(fileName);
					            org.xmlpull.v1.XmlPullParserFactory factory = org.xmlpull.v1.XmlPullParserFactory.newInstance();
					            org.xmlpull.v1.XmlPullParser parser = factory.newPullParser();
					            parser.setInput(is, "UTF-8");
					            
					            int eventType = parser.getEventType();
					            boolean correctSurah = false;
					            
					            while (eventType != org.xmlpull.v1.XmlPullParser.END_DOCUMENT) {
						                if (eventType == org.xmlpull.v1.XmlPullParser.START_TAG) {
							                    String tagName = parser.getName().toLowerCase();
							                    
							                    if (tagName.equals("aya") || tagName.equals("ayah")) {
								                        String sId = parser.getAttributeValue(null, "sora");
								                        if (sId == null) sId = parser.getAttributeValue(null, "sura");
								                        if (sId == null) sId = parser.getAttributeValue(null, "surah");
								                        
								                        String aId = parser.getAttributeValue(null, "id");
								                        if (aId == null) aId = parser.getAttributeValue(null, "aya");
								                        if (aId == null) aId = parser.getAttributeValue(null, "index");
								                        
								                        if (sId != null && aId != null) {
									                            if (sId.equals(String.valueOf(surah)) && aId.equals(String.valueOf(ayah))) {
										                                String textAttr = parser.getAttributeValue(null, "text");
										                                if (textAttr != null) return textAttr;
										                                return parser.nextText();
										                            }
									                        } else if (correctSurah) {
									                            if (aId != null && aId.equals(String.valueOf(ayah))) {
										                                String textAttr = parser.getAttributeValue(null, "text");
										                                if (textAttr != null) return textAttr;
										                                return parser.nextText();
										                            }
									                        }
								                    } 
							                    else if (tagName.equals("sora") || tagName.equals("sura") || tagName.equals("surah")) {
								                        String sId = parser.getAttributeValue(null, "id");
								                        if (sId == null) sId = parser.getAttributeValue(null, "index");
								                        if (sId != null && sId.equals(String.valueOf(surah))) correctSurah = true;
								                        else correctSurah = false;
								                    }
							                }
						                eventType = parser.next();
						            }
					        } catch (java.io.FileNotFoundException e) {
					            return "ملف غير موجود. تأكد من وضع '" + fileName + "' في مجلد assets.";
					        } catch (Exception e) { 
					            return "خطأ في قراءة ملف " + fileName + ":\n" + e.toString(); 
					        }
				        return "لم يتم العثور على تفسير لهذه الآية في الملف.";
				    }
		};
		
		// ==========================================================
		// التحديث الجديد: أزرار التبديل، الخط العريض، الشفافية، و setHighlighter
		// ==========================================================
		abstract class UIAction {
			    abstract void showTafsirDialog(String surahName, int surahId, int ayahId);
			    abstract void shareAyah(String text, String surahName, int ayahNum);
		}
		final UIAction uiAction = new UIAction() {
			    @Override
			    void showTafsirDialog(String surahName, final int surahId, final int ayahId) {
				        com.google.android.material.bottomsheet.BottomSheetDialog dialog = new com.google.android.material.bottomsheet.BottomSheetDialog(SearchActivity.this);
				        android.widget.LinearLayout sheetLayout = new android.widget.LinearLayout(SearchActivity.this);
				        sheetLayout.setOrientation(android.widget.LinearLayout.VERTICAL);
				        sheetLayout.setPadding(60, 60, 60, 60);
				        sheetLayout.setBackgroundColor(isDarkMode ? android.graphics.Color.parseColor("#1E1E1E") : android.graphics.Color.WHITE);
				        
				        // العنوان
				        android.widget.TextView title = new android.widget.TextView(SearchActivity.this);
				        title.setText("تفسير " + surahName + " (آية " + ayahId + ")");
				        title.setTextSize(20);
				        title.setTypeface(quranFont, android.graphics.Typeface.BOLD);
				        title.setTextColor(android.graphics.Color.parseColor("#388E3C"));
				        title.setPadding(0, 0, 0, 40);
				        sheetLayout.addView(title);
				        
				        // حاوية أزرار التبديل (Tabs)
				        android.widget.LinearLayout tabsLayout = new android.widget.LinearLayout(SearchActivity.this);
				        tabsLayout.setOrientation(android.widget.LinearLayout.HORIZONTAL);
				        tabsLayout.setPadding(0, 0, 0, 40);
				        
				        final android.widget.TextView btnMuyassar = new android.widget.TextView(SearchActivity.this);
				        btnMuyassar.setText("التفسير الميسر");
				        btnMuyassar.setTextSize(14);
				        btnMuyassar.setGravity(android.view.Gravity.CENTER);
				        btnMuyassar.setPadding(20, 20, 20, 20);
				        android.widget.LinearLayout.LayoutParams tabParams = new android.widget.LinearLayout.LayoutParams(0, -2, 1f);
				        tabParams.setMargins(10, 0, 10, 0);
				        btnMuyassar.setLayoutParams(tabParams);
				        
				        final android.widget.TextView btnJalalayn = new android.widget.TextView(SearchActivity.this);
				        btnJalalayn.setText("تفسير الجلالين");
				        btnJalalayn.setTextSize(14);
				        btnJalalayn.setGravity(android.view.Gravity.CENTER);
				        btnJalalayn.setPadding(20, 20, 20, 20);
				        btnJalalayn.setLayoutParams(tabParams);
				        
				        tabsLayout.addView(btnMuyassar);
				        tabsLayout.addView(btnJalalayn);
				        sheetLayout.addView(tabsLayout);
				        
				        // نص التفسير
				        final android.widget.TextView txtTafsir = new android.widget.TextView(SearchActivity.this);
				        txtTafsir.setTextSize(18);
				        // جعل النص عريض وتطبيق الخط المخصص
				        txtTafsir.setTypeface(quranFont, android.graphics.Typeface.BOLD);
				        // شفافية 50%
				        txtTafsir.setAlpha(0.5f);
				        txtTafsir.setTextColor(isDarkMode ? android.graphics.Color.WHITE : android.graphics.Color.BLACK);
				        txtTafsir.setLineSpacing(0, 1.4f);
				        sheetLayout.addView(txtTafsir);
				        
				        // جلب النصوص
				        final String textMuyassar = tafsirHelper.getTafsirText("almuyassar.xml", surahId, ayahId);
				        final String textJalalayn = tafsirHelper.getTafsirText("aljalalayn.xml", surahId, ayahId);
				        
				        // منطق التبديل بين التفسيرين
				        abstract class TabSwitcher { abstract void select(boolean isMuyassar); }
				        final TabSwitcher switcher = new TabSwitcher() {
					            @Override
					            void select(boolean isMuyassar) {
						                // تلوين الأزرار
						                android.graphics.drawable.GradientDrawable bgActive = new android.graphics.drawable.GradientDrawable();
						                bgActive.setColor(android.graphics.Color.parseColor("#388E3C"));
						                bgActive.setCornerRadius(20f);
						                
						                android.graphics.drawable.GradientDrawable bgInactive = new android.graphics.drawable.GradientDrawable();
						                bgInactive.setColor(isDarkMode ? android.graphics.Color.parseColor("#333333") : android.graphics.Color.parseColor("#E0E0E0"));
						                bgInactive.setCornerRadius(20f);
						                
						                btnMuyassar.setBackground(isMuyassar ? bgActive : bgInactive);
						                btnMuyassar.setTextColor(isMuyassar ? android.graphics.Color.WHITE : android.graphics.Color.GRAY);
						                
						                btnJalalayn.setBackground(!isMuyassar ? bgActive : bgInactive);
						                btnJalalayn.setTextColor(!isMuyassar ? android.graphics.Color.WHITE : android.graphics.Color.GRAY);
						                
						                // تغيير النص
						                txtTafsir.setText(isMuyassar ? textMuyassar : textJalalayn);
						                
						                // استدعاء المور بلوك setHighlighter
						                // Sketchware يضيف دائماً (_) قبل اسم البلوك، فيكون _setHighlighter
						                try {
							                    // إذا كان البلوك في Sketchware يستقبل متغير View أو TextView
							                    _setHighlighter(txtTafsir);
							                } catch (Exception e) {}
						            }
					        };
				        
				        btnMuyassar.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) { switcher.select(true); }
					        });
				        btnJalalayn.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) { switcher.select(false); }
					        });
				        
				        // الافتراضي هو الميسر
				        switcher.select(true);
				        
				        android.widget.ScrollView scrollView = new android.widget.ScrollView(SearchActivity.this);
				        scrollView.addView(sheetLayout);
				        dialog.setContentView(scrollView);
				        dialog.show();
				    }
			    
			    @Override
			    void shareAyah(String text, String surahName, int ayahNum) {
				        android.content.Intent sendIntent = new android.content.Intent();
				        sendIntent.setAction(android.content.Intent.ACTION_SEND);
				        sendIntent.putExtra(android.content.Intent.EXTRA_TEXT, text + " ﴿" + surahName + ": " + ayahNum + "﴾");
				        sendIntent.setType("text/plain");
				        startActivity(android.content.Intent.createChooser(sendIntent, "مشاركة الآية"));
				    }
		};
		
		// ==========================================================
		// 4. خوارزمية التنظيف وإعداد RecyclerView السريع
		// ==========================================================
		class SearchHelper {
			    String normalize(String text) {
				        if(text == null) return "";
				        return text.replaceAll("[\u0610-\u061A\u064B-\u065F\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED\u0670]", "")
				                   .replaceAll("[أإآٱ]", "ا").replaceAll("[ة]", "ه").replaceAll("[ىئ]", "ي").replaceAll("[ؤ]", "و").replaceAll("[ء]", "");
				    }
		}
		final SearchHelper sh = new SearchHelper();
		
		final java.util.ArrayList<String> allAyahsOrig = new java.util.ArrayList<>();
		final java.util.ArrayList<String> allAyahsClean = new java.util.ArrayList<>();
		final java.util.ArrayList<Integer> allAyahsNum = new java.util.ArrayList<>();
		final java.util.ArrayList<Integer> allAyahsSurah = new java.util.ArrayList<>();
		final java.util.ArrayList<Integer> allAyahsPage = new java.util.ArrayList<>();
		final java.util.ArrayList<String> surahNames = new java.util.ArrayList<>();
		
		class AyahResult {
			    int surahId, aNum, page;
			    String sName;
			    android.text.SpannableString highlightedText;
		}
		final java.util.ArrayList<AyahResult> searchResultsList = new java.util.ArrayList<>();
		
		final androidx.recyclerview.widget.RecyclerView rvResults = new androidx.recyclerview.widget.RecyclerView(this);
		rvResults.setLayoutManager(new androidx.recyclerview.widget.LinearLayoutManager(this));
		rvResults.setLayoutParams(new android.widget.LinearLayout.LayoutParams(-1, -1));
		rvResults.setPadding(30, 10, 30, 40);
		rvResults.setClipToPadding(false);
		
		abstract class RvAdapter extends androidx.recyclerview.widget.RecyclerView.Adapter<androidx.recyclerview.widget.RecyclerView.ViewHolder> {}
		final RvAdapter adapter = new RvAdapter() {
			    class ViewHolder extends androidx.recyclerview.widget.RecyclerView.ViewHolder {
				        android.widget.TextView tvSurahName, tvStar, tvPage, tvAyah, btnTafsir, btnShare;
				        android.widget.LinearLayout card;
				        
				        public ViewHolder(android.view.View v) {
					            super(v);
					            card = (android.widget.LinearLayout) v;
					            android.widget.LinearLayout header = (android.widget.LinearLayout) card.getChildAt(0);
					            tvSurahName = (android.widget.TextView) header.getChildAt(0);
					            tvStar = (android.widget.TextView) header.getChildAt(1);
					            tvPage = (android.widget.TextView) header.getChildAt(2);
					            tvAyah = (android.widget.TextView) card.getChildAt(1);
					            
					            android.widget.LinearLayout footer = (android.widget.LinearLayout) card.getChildAt(2);
					            btnTafsir = (android.widget.TextView) footer.getChildAt(0);
					            btnShare = (android.widget.TextView) footer.getChildAt(1);
					        }
				    }
			
			    @Override
			    public androidx.recyclerview.widget.RecyclerView.ViewHolder onCreateViewHolder(android.view.ViewGroup parent, int viewType) {
				        android.widget.LinearLayout card = new android.widget.LinearLayout(SearchActivity.this);
				        card.setOrientation(android.widget.LinearLayout.VERTICAL);
				        card.setPadding(40, 40, 40, 40);
				        card.setElevation(15f);
				        android.graphics.drawable.GradientDrawable cardBg = new android.graphics.drawable.GradientDrawable();
				        cardBg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2C2C2C") : android.graphics.Color.WHITE);
				        cardBg.setCornerRadius(30f);
				        card.setBackground(cardBg);
				        androidx.recyclerview.widget.RecyclerView.LayoutParams params = new androidx.recyclerview.widget.RecyclerView.LayoutParams(-1, -2);
				        params.setMargins(0, 0, 0, 35);
				        card.setLayoutParams(params);
				
				        android.widget.LinearLayout headerRow = new android.widget.LinearLayout(SearchActivity.this);
				        headerRow.setOrientation(android.widget.LinearLayout.HORIZONTAL);
				        headerRow.setGravity(android.view.Gravity.CENTER_VERTICAL);
				        headerRow.setPadding(0, 0, 0, 25);
				
				        android.widget.TextView tvSurahName = new android.widget.TextView(SearchActivity.this);
				        tvSurahName.setTextColor(android.graphics.Color.parseColor("#388E3C"));
				        tvSurahName.setTypeface(android.graphics.Typeface.DEFAULT_BOLD);
				        tvSurahName.setTextSize(14);
				        android.widget.LinearLayout.LayoutParams nameParams = new android.widget.LinearLayout.LayoutParams(0, -2, 1f);
				        tvSurahName.setLayoutParams(nameParams);
				        headerRow.addView(tvSurahName);
				
				        android.widget.TextView tvStar = new android.widget.TextView(SearchActivity.this);
				        tvStar.setTextColor(android.graphics.Color.WHITE);
				        tvStar.setTextSize(12);
				        tvStar.setGravity(android.view.Gravity.CENTER);
				        tvStar.setPadding(20, 5, 20, 5);
				        android.graphics.drawable.GradientDrawable starBg = new android.graphics.drawable.GradientDrawable();
				        starBg.setColor(android.graphics.Color.parseColor("#4CAF50"));
				        starBg.setCornerRadius(20f);
				        tvStar.setBackground(starBg);
				        android.widget.LinearLayout.LayoutParams starParams = new android.widget.LinearLayout.LayoutParams(-2, -2);
				        starParams.setMargins(0, 0, 20, 0);
				        tvStar.setLayoutParams(starParams);
				        headerRow.addView(tvStar);
				
				        android.widget.TextView tvPage = new android.widget.TextView(SearchActivity.this);
				        tvPage.setTextColor(android.graphics.Color.GRAY);
				        tvPage.setTextSize(12);
				        headerRow.addView(tvPage);
				        card.addView(headerRow);
				
				        android.widget.TextView tvAyah = new android.widget.TextView(SearchActivity.this);
				        tvAyah.setTextSize(22);
				        tvAyah.setTypeface(quranFont);
				        tvAyah.setTextColor(isDarkMode ? android.graphics.Color.parseColor("#E0E0E0") : android.graphics.Color.BLACK);
				        tvAyah.setLineSpacing(0, 1.3f);
				        tvAyah.setGravity(android.view.Gravity.RIGHT);
				        card.addView(tvAyah);
				
				        android.widget.LinearLayout footerRow = new android.widget.LinearLayout(SearchActivity.this);
				        footerRow.setOrientation(android.widget.LinearLayout.HORIZONTAL);
				        footerRow.setGravity(android.view.Gravity.LEFT);
				        footerRow.setPadding(0, 40, 0, 10);
				        
				        android.widget.LinearLayout.LayoutParams btnParams = new android.widget.LinearLayout.LayoutParams(-2, -2);
				        btnParams.setMargins(20, 0, 0, 0);
				        
				        android.widget.TextView btnTafsir = new android.widget.TextView(SearchActivity.this);
				        btnTafsir.setText("📖 التفسير");
				        btnTafsir.setTextSize(14);
				        btnTafsir.setTextColor(android.graphics.Color.WHITE);
				        btnTafsir.setPadding(45, 20, 45, 20);
				        android.graphics.drawable.GradientDrawable bgTafsir = new android.graphics.drawable.GradientDrawable();
				        bgTafsir.setColor(isDarkMode ? android.graphics.Color.parseColor("#2E7D32") : android.graphics.Color.parseColor("#388E3C"));
				        bgTafsir.setCornerRadius(15f);
				        btnTafsir.setBackground(bgTafsir);
				        btnTafsir.setLayoutParams(btnParams);
				        
				        android.widget.TextView btnShare = new android.widget.TextView(SearchActivity.this);
				        btnShare.setText("📤 مشاركة");
				        btnShare.setTextSize(14);
				        btnShare.setTextColor(android.graphics.Color.WHITE);
				        btnShare.setPadding(45, 20, 45, 20);
				        android.graphics.drawable.GradientDrawable bgShare = new android.graphics.drawable.GradientDrawable();
				        bgShare.setColor(isDarkMode ? android.graphics.Color.parseColor("#1565C0") : android.graphics.Color.parseColor("#1976D2"));
				        bgShare.setCornerRadius(15f);
				        btnShare.setBackground(bgShare);
				        btnShare.setLayoutParams(btnParams);
				        
				        footerRow.addView(btnTafsir);
				        footerRow.addView(btnShare);
				        card.addView(footerRow);
				
				        return new ViewHolder(card);
				    }
			
			    @Override
			    public void onBindViewHolder(androidx.recyclerview.widget.RecyclerView.ViewHolder h, int position) {
				        final ViewHolder holder = (ViewHolder) h;
				        final AyahResult item = searchResultsList.get(position);
				        
				        holder.tvSurahName.setText(item.sName);
				        holder.tvStar.setText(String.valueOf(item.aNum));
				        holder.tvPage.setText("ص " + item.page);
				        holder.tvAyah.setText(item.highlightedText);
				        
				        holder.card.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                android.content.Intent intent = new android.content.Intent(SearchActivity.this, ReadingActivity.class);
						                intent.putExtra("surah_id", String.valueOf(item.surahId));
						                intent.putExtra("ayah_id", String.valueOf(item.aNum));
						                startActivity(intent);
						            }
					        });
				        
				        holder.btnTafsir.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                uiAction.showTafsirDialog(item.sName, item.surahId, item.aNum);
						            }
					        });
				        
				        holder.btnShare.setOnClickListener(new android.view.View.OnClickListener() {
					            @Override public void onClick(android.view.View v) {
						                uiAction.shareAyah(item.highlightedText.toString(), item.sName, item.aNum);
						            }
					        });
				    }
			
			    @Override public int getItemCount() { return searchResultsList.size(); }
		};
		rvResults.setAdapter(adapter);
		rootLayout.addView(rvResults);
		
		rvResults.addOnScrollListener(new androidx.recyclerview.widget.RecyclerView.OnScrollListener() {
			    @Override
			    public void onScrollStateChanged(androidx.recyclerview.widget.RecyclerView recyclerView, int newState) {
				        if (newState == androidx.recyclerview.widget.RecyclerView.SCROLL_STATE_DRAGGING) {
					            android.view.inputmethod.InputMethodManager imm = (android.view.inputmethod.InputMethodManager) getSystemService(android.content.Context.INPUT_METHOD_SERVICE);
					            imm.hideSoftInputFromWindow(inputSearch.getWindowToken(), 0);
					        }
				    }
		});
		
		abstract class HistoryManager { abstract void refresh(); }
		final HistoryManager historyManager = new HistoryManager() {
			    @Override
			    void refresh() {
				        suggestionsContainer.removeAllViews();
				        String historyStr = searchHistoryPrefs.getString("history_list", "بسم|سنة|افترى|العلق|ليس");
				        String[] historyArray = historyStr.split("\\|");
				        for (final String word : historyArray) {
					            if (word.trim().isEmpty()) continue;
					            android.widget.Button btn = new android.widget.Button(SearchActivity.this);
					            btn.setText(word);
					            btn.setTextSize(14);
					            btn.setTextColor(isDarkMode ? android.graphics.Color.parseColor("#E0E0E0") : android.graphics.Color.BLACK);
					            android.graphics.drawable.GradientDrawable btnBg = new android.graphics.drawable.GradientDrawable();
					            btnBg.setColor(isDarkMode ? android.graphics.Color.parseColor("#2A2A2A") : android.graphics.Color.parseColor("#E8E5D3"));
					            btnBg.setCornerRadius(30f);
					            btn.setBackground(btnBg);
					            btn.setPadding(35, 15, 35, 15);
					            android.widget.LinearLayout.LayoutParams params = new android.widget.LinearLayout.LayoutParams(-2, -2);
					            params.setMargins(0, 0, 15, 0);
					            btn.setLayoutParams(params);
					            btn.setOnClickListener(new android.view.View.OnClickListener() {
						                @Override public void onClick(android.view.View v) {
							                    inputSearch.setText(word);
							                    inputSearch.setSelection(word.length());
							                }
						            });
					            suggestionsContainer.addView(btn);
					        }
				    }
		};
		
		// ==========================================================
		// 5. محرك البحث (الرسم العثماني الذكي)
		// ==========================================================
		abstract class SearchAction { abstract void execute(String query); }
		final SearchAction performSearch = new SearchAction() {
			    @Override
			    void execute(String query) {
				        searchResultsList.clear();
				        adapter.notifyDataSetChanged();
				        
				        if (query.isEmpty()) {
					            tvStats.setText("السور: 0, الآيات: 0");
					            tvStatus.setVisibility(android.view.View.GONE);
					            return;
					        }
				
				        String cleanQuery = sh.normalize(query);
				        if (cleanQuery.isEmpty()) return;
				        
				        java.util.HashSet<Integer> surahSet = new java.util.HashSet<>();
				        boolean exactMatch = cbExactMatch.isChecked();
				        
				        StringBuilder searchPatternBuilder = new StringBuilder();
				        for (int c = 0; c < cleanQuery.length(); c++) {
					            char ch = cleanQuery.charAt(c);
					            if (ch == 'ا') searchPatternBuilder.append("[اوي]?"); 
					            else if (ch == ' ') searchPatternBuilder.append("\\s+");
					            else searchPatternBuilder.append(ch);
					        }
				        
				        java.util.regex.Pattern searchPattern;
				        if (exactMatch) searchPattern = java.util.regex.Pattern.compile("(?:^|\\s)(" + searchPatternBuilder.toString() + ")(?:\\s|$)");
				        else searchPattern = java.util.regex.Pattern.compile(searchPatternBuilder.toString());
				
				        StringBuilder hlRegexBuilder = new StringBuilder();
				        String TASHKEEL = "[\u0610-\u061A\u064B-\u065F\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED\u0670]*";
				        for (int c = 0; c < cleanQuery.length(); c++) {
					            char ch = cleanQuery.charAt(c);
					            if (ch == 'ا') hlRegexBuilder.append("([اأإآٱويىئ]\\s*").append(TASHKEEL).append(")?");
					            else if (ch == ' ') hlRegexBuilder.append("\\s+").append(TASHKEEL);
					            else if (ch == 'ه') hlRegexBuilder.append("[هة]\\s*").append(TASHKEEL);
					            else if (ch == 'ي') hlRegexBuilder.append("[يىئ]\\s*").append(TASHKEEL);
					            else if (ch == 'و') hlRegexBuilder.append("[وؤ]\\s*").append(TASHKEEL);
					            else hlRegexBuilder.append(java.util.regex.Pattern.quote(String.valueOf(ch))).append("\\s*").append(TASHKEEL);
					        }
				        java.util.regex.Pattern highlightPattern = java.util.regex.Pattern.compile(hlRegexBuilder.toString());
				
				        for (int i = 0; i < allAyahsClean.size(); i++) {
					            String cleanAyah = allAyahsClean.get(i);
					            java.util.regex.Matcher searchMatcher = searchPattern.matcher(cleanAyah);
					            
					            if (searchMatcher.find()) {
						                surahSet.add(allAyahsSurah.get(i));
						                AyahResult result = new AyahResult();
						                result.surahId = allAyahsSurah.get(i);
						                result.aNum = allAyahsNum.get(i);
						                result.page = allAyahsPage.get(i);
						                result.sName = surahNames.size() >= result.surahId ? surahNames.get(result.surahId - 1) : "سورة " + result.surahId;
						                
						                String ayahText = allAyahsOrig.get(i);
						                result.highlightedText = new android.text.SpannableString(ayahText);
						                java.util.regex.Matcher hlMatcher = highlightPattern.matcher(ayahText);
						                while (hlMatcher.find()) {
							                    result.highlightedText.setSpan(new android.text.style.ForegroundColorSpan(android.graphics.Color.parseColor("#1976D2")), 
							                                      hlMatcher.start(), hlMatcher.end(), android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                    result.highlightedText.setSpan(new android.text.style.StyleSpan(android.graphics.Typeface.BOLD), 
							                                      hlMatcher.start(), hlMatcher.end(), android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
							                }
						                
						                searchResultsList.add(result);
						                if (searchResultsList.size() >= 500) break;
						            }
					        }
				        
				        adapter.notifyDataSetChanged();
				        tvStats.setText("السور: " + surahSet.size() + ", الآيات: " + searchResultsList.size());
				        
				        if (searchResultsList.isEmpty()) {
					            tvStatus.setText("لم يتم العثور على نتائج ❌");
					            tvStatus.setVisibility(android.view.View.VISIBLE);
					        } else {
					            tvStatus.setVisibility(android.view.View.GONE);
					        }
				    }
		};
		
		// ==========================================================
		// 6. تحميل البيانات والربط بالأحداث
		// ==========================================================
		new Thread(new Runnable() {
			    @Override
			    public void run() {
				        try {
					            java.io.InputStream isIndex = getAssets().open("index.json");
					            java.util.Scanner scIndex = new java.util.Scanner(isIndex).useDelimiter("\\A");
					            org.json.JSONArray indexArray = new org.json.JSONArray(scIndex.hasNext() ? scIndex.next() : "");
					            scIndex.close();
					            for (int i = 0; i < indexArray.length(); i++) surahNames.add(indexArray.getJSONObject(i).getString("name"));
					
					            java.io.InputStream isAyat = getAssets().open("ayat.json");
					            java.util.Scanner scAyat = new java.util.Scanner(isAyat).useDelimiter("\\A");
					            org.json.JSONArray surahsArray = new org.json.JSONArray(scAyat.hasNext() ? scAyat.next() : "");
					            scAyat.close();
					
					            for (int i = 0; i < surahsArray.length(); i++) {
						                org.json.JSONArray vs = surahsArray.getJSONObject(i).getJSONArray("verses");
						                int surahId = i + 1;
						                for (int j = 0; j < vs.length(); j++) {
							                    org.json.JSONObject vObj = vs.getJSONObject(j);
							                    String text = vObj.getJSONObject("text").getString("ar");
							                    allAyahsOrig.add(text);
							                    allAyahsClean.add(sh.normalize(text));
							                    allAyahsNum.add(vObj.getInt("number"));
							                    allAyahsSurah.add(surahId);
							                    allAyahsPage.add(vObj.has("page") ? vObj.getInt("page") : 1);
							                }
						            }
					
					            runOnUiThread(new Runnable() {
						                @Override public void run() {
							                    inputSearch.setEnabled(true);
							                    tvStatus.setText("جاهز! ابحث فوراً ⚡");
							                    tvStatus.setTextColor(android.graphics.Color.GRAY);
							                    historyManager.refresh();
							                }
						            });
					        } catch (Exception e) {}
				    }
		}).start();
		
		inputSearch.addTextChangedListener(new android.text.TextWatcher() {
			    android.os.Handler handler = new android.os.Handler(android.os.Looper.getMainLooper());
			    Runnable searchRunnable, saveHistoryRunnable;
			
			    @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
			    @Override public void onTextChanged(CharSequence s, int start, int before, int count) {}
			
			    @Override
			    public void afterTextChanged(final android.text.Editable s) {
				        if (searchRunnable != null) handler.removeCallbacks(searchRunnable);
				        if (saveHistoryRunnable != null) handler.removeCallbacks(saveHistoryRunnable);
				        
				        final String query = s.toString().trim();
				        searchRunnable = new Runnable() { @Override public void run() { performSearch.execute(query); } };
				        handler.postDelayed(searchRunnable, 300);
				
				        saveHistoryRunnable = new Runnable() {
					            @Override
					            public void run() {
						                if (query.length() >= 3) {
							                    String historyStr = searchHistoryPrefs.getString("history_list", "بسم|سنة|افترى|العلق|ليس");
							                    java.util.List<String> historyList = new java.util.ArrayList<>(java.util.Arrays.asList(historyStr.split("\\|")));
							                    historyList.remove(query);
							                    historyList.add(0, query);
							                    if (historyList.size() > 15) historyList = historyList.subList(0, 15);
							                    searchHistoryPrefs.edit().putString("history_list", android.text.TextUtils.join("|", historyList)).apply();
							                    historyManager.refresh();
							                }
						            }
					        };
				        handler.postDelayed(saveHistoryRunnable, 1500);
				    }
		});
		
		cbExactMatch.setOnCheckedChangeListener(new android.widget.CompoundButton.OnCheckedChangeListener() {
			    @Override
			    public void onCheckedChanged(android.widget.CompoundButton buttonView, boolean isChecked) {
				        performSearch.execute(inputSearch.getText().toString().trim());
				    }
		});
		
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