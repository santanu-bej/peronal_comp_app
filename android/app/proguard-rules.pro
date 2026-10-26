# security-crypto (Tink) references annotation-only classes that R8 cannot find
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-dontwarn javax.annotation.concurrent.**
-dontwarn org.checkerframework.**
-dontwarn com.google.crypto.tink.**
-keep class com.google.crypto.tink.** { *; }
# OkHttp / Okio optional platforms
-dontwarn okhttp3.internal.platform.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**
# native services and receivers are referenced from the manifest
-keep class com.teqsonic.goalcompass.** { *; }
