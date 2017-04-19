/*
        ##########    Copyright (C) 2017 Vincenzo Pacella
        ##      ##    Distributed under MIT license, see file LICENSE
        ##      ##    or <http://opensource.org/licenses/MIT>
        ##      ##
##########      ############################################################# shaduzlabs.com #####*/

#pragma once

#include <algorithm>
#include <atomic>
#include <chrono>
#include <string>

#include "JuceHeader.h"

//--------------------------------------------------------------------------------------------------

class PluginAudioProcessor final : public AudioProcessor
{
public:
  PluginAudioProcessor() = default;
  ~PluginAudioProcessor() override = default;

  void prepareToPlay(double sampleRate, int samplesPerBlock) override;
  void releaseResources() override;

#ifndef JucePlugin_PreferredChannelConfigurations
  bool setPreferredBusArrangement(
    bool isInput, int bus, const AudioChannelSet& preferredSet) override;
#endif

  void processBlock(AudioSampleBuffer&, MidiBuffer&) override;

  AudioProcessorEditor* createEditor() override;
  bool hasEditor() const override;

  const String getName() const override;

  bool acceptsMidi() const override;
  bool producesMidi() const override;
  double getTailLengthSeconds() const override;

  int getNumPrograms() override;
  int getCurrentProgram() override;
  void setCurrentProgram(int index) override;
  const String getProgramName(int index) override;
  void changeProgramName(int index, const String& newName) override;

  void getStateInformation(MemoryBlock& destData) override;
  void setStateInformation(const void* data, int sizeInBytes) override;

  void setGain(double gain_)
  {
    m_gain = gain_;
  }

  double gain() const
  {
    return m_gain;
  }

  int getNumParameters() override
  {
    return 1;
  }
  const String getParameterName(int parameterIndex) override
  {
    return "value";
  }
  float getParameter(int parameterIndex) override
  {
    return static_cast<float>(m_gain);
  }
  const String getParameterText(int parameterIndex_) override
  {
    if (parameterIndex_ == 0)
    {
      return std::to_string(m_gain);
    }
    return "";
  }
  int getParameterNumSteps(int parameterIndex) override
  {
    return 0;
  }
  float getParameterDefaultValue(int parameterIndex) override
  {
    return 1.f;
  }
  bool isParameterAutomatable(int index) const override
  {
    return (index == 0);
  }
  void setParameter(int parameterIndex, float newValue) override
  {
    if (parameterIndex != 0)
    {
      return;
    }
    m_gain = std::min<double>(2., std::max<double>(0., newValue));
  }

private:
  double m_gain{1.};

  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(PluginAudioProcessor)
};

//--------------------------------------------------------------------------------------------------
