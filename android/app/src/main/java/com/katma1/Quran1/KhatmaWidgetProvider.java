package com.katma1.Quran1;

import com.example.sanad_app.R;
import android.app.PendingIntent;
import com.example.sanad_app.R;
import android.appwidget.AppWidgetManager;
import com.example.sanad_app.R;
import android.appwidget.AppWidgetProvider;
import com.example.sanad_app.R;
import android.content.Context;
import com.example.sanad_app.R;
import android.content.Intent;
import com.example.sanad_app.R;
import android.content.SharedPreferences;
import com.example.sanad_app.R;
import android.widget.RemoteViews;

public class KhatmaWidgetProvider extends AppWidgetProvider {
    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        try {
            // 1. جلب البيانات من تطبيقك
            SharedPreferences prefs = context.getSharedPreferences("QuranPrefs", Context.MODE_PRIVATE);
            SharedPreferences memoData = context.getSharedPreferences("memo_data", Context.MODE_PRIVATE);

            // حساب إجمالي حفظ القرآن
            int totalMemo = 0;
            for (int i = 1; i <= 114; i++) {
                try {
                    totalMemo += Integer.parseInt(memoData.getString("surah_" + i + "_saved", "0"));
                } catch (Exception e) {}
            }
            float overallProgress = ((float) totalMemo / 6236f) * 100f;

            // جلب تقدم الختمة ونص الورد التالي
            float khatmaProgress = prefs.getFloat("khatma_progress", 0f);
            String nextWirdStr = prefs.getString("current_wird_text", "من الفاتحة 1 إلى البقرة 141");

            // 2. ربط الواجهة
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_khatma);

            // 3. تحديث النصوص وأشرطة التقدم
            views.setTextViewText(R.id.widget_overall_text, "إجمالي الحفظ من القرآن: " + (int) overallProgress + "%");
            views.setProgressBar(R.id.widget_overall_progress, 100, (int) overallProgress, false);

            views.setTextViewText(R.id.widget_wird_details, "الورد التالي:\n" + nextWirdStr);
            views.setProgressBar(R.id.widget_wird_progress, 100, (int) khatmaProgress, false);

            // 4. إعداد الأزرار والـ Intents للعمل بشكل آمن مع كل إصدارات أندرويد
            int pendingFlags = android.os.Build.VERSION.SDK_INT >= 23 ? 
                (PendingIntent.FLAG_UPDATE_CURRENT | 67108864) : PendingIntent.FLAG_UPDATE_CURRENT;

            // زر المتابعة
            Intent readIntent = new Intent(context, ReadingActivity.class);
            readIntent.putExtra("continue_khatma", true);
            PendingIntent readPi = PendingIntent.getActivity(context, 0, readIntent, pendingFlags);
            views.setOnClickPendingIntent(R.id.btn_widget_continue, readPi);

            // زر البحث
            Intent searchIntent = new Intent(context, SearchActivity.class);
            PendingIntent searchPi = PendingIntent.getActivity(context, 1, searchIntent, pendingFlags);
            views.setOnClickPendingIntent(R.id.btn_widget_search, searchPi);

            // زر المفضلة
            Intent favIntent = new Intent(context, BookmarksActivity.class);
            PendingIntent favPi = PendingIntent.getActivity(context, 2, favIntent, pendingFlags);
            views.setOnClickPendingIntent(R.id.btn_widget_fav, favPi);

            // زر التفاصيل (نفتحه عبر MainActivity)
            Intent mainIntent = new Intent(context, MainActivity.class);
            mainIntent.putExtra("show_khatma_plan", true);
            PendingIntent mainPi = PendingIntent.getActivity(context, 3, mainIntent, pendingFlags);
            views.setOnClickPendingIntent(R.id.btn_widget_details, mainPi);

            // 5. التحديث النهائي للويدجت
            appWidgetManager.updateAppWidget(appWidgetId, views);
            
        } catch (Exception e) {
            // منع الانهيار في حال حدوث أي خطأ
        }
    }
}
