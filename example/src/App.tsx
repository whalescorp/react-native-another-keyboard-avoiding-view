import * as React from 'react';

import { SafeAreaView } from 'react-native';
import { AnotherKeyboardAvoidingView } from 'react-native-another-keyboard-avoiding-view';
import { WebView } from 'react-native-webview';

export default function App() {
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <AnotherKeyboardAvoidingView style={{ flex: 1 }}>
        <WebView
          style={{ flex: 1 }}
          source={{ uri: 'https://next.zenpay.org' }}
        />
      </AnotherKeyboardAvoidingView>
    </SafeAreaView>
  );
}
