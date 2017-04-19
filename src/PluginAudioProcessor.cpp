/*
        ##########    Copyright (C) 2017 Vincenzo Pacella
        ##      ##    Distributed under MIT license, see file LICENSE
        ##      ##    or <http://opensource.org/licenses/MIT>
        ##      ##
##########      ############################################################# shaduzlabs.com #####*/

#include "PluginAudioProcessor.h"
#include "PluginAudioProcessorEditor.h"

#include <string>

//--------------------------------------------------------------------------------------------------

const String PluginAudioProcessor::getName() const
{
  return "Gain";
}

//--------------------------------------------------------------------------------------------------

bool PluginAudioProcessor::acceptsMidi() const
{
#if JucePlugin_WantsMidiInput
  return true;
#else
  return false;
#endif
}

//--------------------------------------------------------------------------------------------------

bool PluginAudioProcessor::producesMidi() const
{
#if JucePlugin_ProducesMidiOutput
  return true;
#else
  return false;
#endif
}

//--------------------------------------------------------------------------------------------------

double PluginAudioProcessor::getTailLengthSeconds() const
{
  return 0.0;
}

//--------------------------------------------------------------------------------------------------

int PluginAudioProcessor::getNumPrograms()
{
  return 1;
}

//--------------------------------------------------------------------------------------------------

int PluginAudioProcessor::getCurrentProgram()
{
  return 0;
}

//--------------------------------------------------------------------------------------------------

void PluginAudioProcessor::setCurrentProgram(int index)
{
}

//--------------------------------------------------------------------------------------------------

const String PluginAudioProcessor::getProgramName(int index)
{
  return String();
}

//--------------------------------------------------------------------------------------------------

void PluginAudioProcessor::changeProgramName(int index, const String& newName)
{
}

//--------------------------------------------------------------------------------------------------

void PluginAudioProcessor::prepareToPlay(double sampleRate, int samplesPerBlock)
{
}

//--------------------------------------------------------------------------------------------------

void PluginAudioProcessor::releaseResources()
{
}

//--------------------------------------------------------------------------------------------------

#ifndef JucePlugin_PreferredChannelConfigurations
bool PluginAudioProcessor::setPreferredBusArrangement(
  bool isInput, int bus, const AudioChannelSet& preferredSet)
{
  const int numChannels = preferredSet.size();
  if (isInput || (numChannels != 1 && numChannels != 2))
    return false;

  return AudioProcessor::setPreferredBusArrangement(isInput, bus, preferredSet);
}
#endif

//--------------------------------------------------------------------------------------------------

void PluginAudioProcessor::processBlock(AudioSampleBuffer& buffer_, MidiBuffer& /*mm_*/)
{
  for (int i = 0; i < getBlockSize(); ++i)
  {
    buffer_.getWritePointer(0)[i] = buffer_.getReadPointer(0)[i] * m_gain;
    buffer_.getWritePointer(1)[i] = buffer_.getReadPointer(1)[i] * m_gain;
  }
}

//--------------------------------------------------------------------------------------------------

bool PluginAudioProcessor::hasEditor() const
{
  return true;
}

//--------------------------------------------------------------------------------------------------

AudioProcessorEditor* PluginAudioProcessor::createEditor()
{
  return new PluginAudioProcessorEditor(*this);
}

//--------------------------------------------------------------------------------------------------

void PluginAudioProcessor::getStateInformation(MemoryBlock& destData)
{
  XmlElement xml("Gain");
  xml.setAttribute("value", m_gain);
  xml.setAttribute("version", "1.0");
  copyXmlToBinary(xml, destData);
}

//--------------------------------------------------------------------------------------------------

void PluginAudioProcessor::setStateInformation(const void* data, int sizeInBytes)
{
  // You should use this method to restore your parameters from this memory
  // block,
  // whose contents will have been created by the getStateInformation() call.
  ScopedPointer<XmlElement> xmlState(getXmlFromBinary(data, sizeInBytes));
  if (xmlState != 0)
  {
    if (xmlState->hasTagName("Gain"))
    {
      m_gain = xmlState->getDoubleAttribute("gain", 1.);
    }
  }
}

//--------------------------------------------------------------------------------------------------

AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
  return new PluginAudioProcessor();
}

//--------------------------------------------------------------------------------------------------
