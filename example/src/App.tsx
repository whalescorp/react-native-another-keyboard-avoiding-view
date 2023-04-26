import * as React from 'react';

import { StyleSheet, Text, View, TextInput } from 'react-native';
import { AnotherKeyboardAvoidingViewView } from 'react-native-another-keyboard-avoiding-view';

export default function App() {
  return (
    <View style={{ flex: 1 }}>
      <AnotherKeyboardAvoidingViewView style={styles.container}>
        <View style={{ padding: 30, width: '100%', alignItems: 'center' }}>
          <TextInput
            placeholder="Input"
            style={{
              width: '100%',
              borderWidth: 1,
              borderColor: '#000',
              padding: 4,
            }}
          ></TextInput>
        </View>
        <Text>Low text at keyboard</Text>
      </AnotherKeyboardAvoidingViewView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'flex-end',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
