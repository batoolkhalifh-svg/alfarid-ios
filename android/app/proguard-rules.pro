# منع إزالة WebpTranscoder من Fresco
-keep class com.facebook.imagepipeline.nativecode.WebpTranscoder { *; }
-keep class com.facebook.imagepipeline.nativecode.WebpTranscoderImpl { *; }
-dontwarn com.facebook.imagepipeline.nativecode.WebpTranscoder

# الاحتفاظ بجميع الفئات داخل Giphy SDK
-keep class com.giphy.sdk.** { *; }
-keep class com.giphy.sdk.analytics.models.AnalyticsEvent { *; }

# منع إزالة kotlinx.parcelize.Parcelize
-keep class kotlinx.parcelize.Parcelize { *; }
-keep class kotlinx.parcelize.** { *; }
-dontwarn kotlinx.parcelize.Parcelize
