  package autodrive_rzr_aeb_mbse {
    library package DataDictionary;
    package Requirements {
      requirement <'1'> Detection {
        doc /* The perception sub-system shall be able to detect various objects on the road ahead, classify them, and provide the confidence scores of the detections. That is to say that the number of detections throughout the test shall be greater than 1. */
      }
      requirement <'2'> Comfort {
        doc /* The planning sub-system shall ensure passenger comfort while ensuring effectiveness in stopping the vehicle. That is to say that the peak jerk experienced by the RZR shall be less than 6 m/s^3. */
      }
      requirement <'3'> Tracking {
        doc /* The control sub-system shall accurately track the prescribed velocity setpoint, with minimal deviation. That is to say that the average estimated velocity error shall be within acceptable bounds of ±1 m/s. */
      }
      requirement <'4'> Safety {
        doc /* The system shall prevent any collision under all valid scenarios within its operational limits. That is to say that the total number of collisions of the RZR shall be 0. */
      }
    }
    part def AutoDRIVE_RZR_AEB {
      part Simulation {
        out port Weather;
        out port Time;
        in port 'RZR Lights';
        out port 'RZR Encoder';
        in port 'RZR DBW';
        out port 'RZR Camera';
        out port 'RZR Acceleration';
        satisfy $::autodrive_rzr_aeb_mbse::Requirements::Safety;
      }
      part Planning {
        out port Velocity;
        in port Confidence;
        in port Class;
        in port Area;
        satisfy $::autodrive_rzr_aeb_mbse::Requirements::Comfort;
      }
      part Perception {
        out port Confidence;
        out port Class;
        in port Camera;
        out port Area;
        satisfy $::autodrive_rzr_aeb_mbse::Requirements::Detection;
      }
      part Control {
        in port Weather;
        in port 'Velocity Setpoint';
        in port Time;
        out port Lights;
        in port Encoder;
        out port DBW;
        in port Acceleration;
        satisfy $::autodrive_rzr_aeb_mbse::Requirements::Tracking;
      }
      connect Control.Lights to Simulation.'RZR Lights';
      connect Simulation.Weather to Control.Weather;
      connect Planning.Velocity to Control.'Velocity Setpoint';
      connect Simulation.Time to Control.Time;
      connect Perception.Class to Planning.Class;
      connect Perception.Area to Planning.Area;
      connect Simulation.'RZR Encoder' to Control.Encoder;
      connect Perception.Confidence to Planning.Confidence;
      connect Simulation.'RZR Acceleration' to Control.Acceleration;
      connect Simulation.'RZR Camera' to Perception.Camera;
      connect Control.DBW to Simulation.'RZR DBW';
    }
    part def Control {
      in port Weather {
        in attribute ID;
      }
      in port 'Velocity Setpoint';
      in port Time;
      out port Lights;
      in attribute Encoder;
      out port DBW {
        out attribute Throttle;
      }
      in port Acceleration;
    }
    part def Perception {
      out attribute Confidence;
      out attribute Class;
      in attribute Camera;
      out attribute Area;
    }
    part def Planning {
      out port Velocity;
      in attribute Confidence;
      in attribute Class;
      in attribute Area;
    }
    part def Simulation {
      out port Weather {
        out attribute ID;
      }
      out port Time;
      in attribute 'RZR Lights';
      out attribute 'RZR Encoder';
      in port 'RZR DBW' {
        in attribute Throttle;
      }
      out port 'RZR Camera';
      out port 'RZR Acceleration';
    }
  }
