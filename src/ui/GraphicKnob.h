/*
        ##########    Copyright (C) 2017 Vincenzo Pacella
        ##      ##    Distributed under MIT license, see file LICENSE
        ##      ##    or <http://opensource.org/licenses/MIT>
        ##      ##
##########      ############################################################# shaduzlabs.com #####*/

#pragma once

#include "JuceHeader.h"

//--------------------------------------------------------------------------------------------------

class GraphicKnob : public Slider
{
public:
  GraphicKnob(const Image& image_, unsigned nFrames_, bool horizontal_);
  virtual ~GraphicKnob() = default;

  void setImageBackgroundHover(Image* image_)
  {
    m_imageBackgroundHover = image_;
  }

  void paint(Graphics& g) override;
  void resized() override;


private:
  const Image& m_imageBackground;
  unsigned m_nFrames;
  bool m_horizontal;

  int m_frameWidth;
  int m_frameHeight;

  const Image* m_imageBackgroundHover;

  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(GraphicKnob)
};
