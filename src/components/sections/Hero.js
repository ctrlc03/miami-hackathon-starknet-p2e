import React, { useState, useMemo } from 'react';
import classNames from 'classnames';
import { SectionProps } from '../../utils/SectionProps';
import ButtonGroup from '../elements/ButtonGroup';
import Button from '../elements/Button';
// import { useStarknet, InjectedConnector } from '@starknet-react/core'
// import SendCharity from '../../components/functions/SendCharity'; 
import { ethers } from "ethers";
import Web3Modal from "web3modal";
import { providerOptions } from "../coinbase/providerOptions";


const propTypes = {
  ...SectionProps.types
}

const defaultProps = {
  ...SectionProps.defaults
}

const refreshState = () => {
  window.localStorage.setItem("provider", undefined);
};


// const disconnect = () => {
//   refreshState();
//   deactivate();
// };

const Hero = ({
  className,
  topOuterDivider,
  bottomOuterDivider,
  topDivider,
  bottomDivider,
  hasBgColor,
  invertColor,
  ...props
}) => {

  const outerClasses = classNames(
    'hero section center-content',
    topOuterDivider && 'has-top-divider',
    bottomOuterDivider && 'has-bottom-divider',
    hasBgColor && 'has-bg-color',
    invertColor && 'invert-color',
    className
  );

  const innerClasses = classNames(
    'hero-inner section-inner',
    topDivider && 'has-top-divider',
    bottomDivider && 'has-bottom-divider'
  );

  // const { connect, connectors, account } = useStarknet()
  // const { account } = useStarknet()
  // const injected = useMemo(() => new InjectedConnector(), [])
 
  return (
    
    <section
      {...props}
      className={outerClasses}
    >
      
      <div className="container-sm">
        <div className={innerClasses}>
          <div className="hero-content">
            <h1 className="mt-0 mb-16 reveal-from-bottom" data-reveal-delay="200">
              Play2help - <span className="text-color-primary">make charity fun!</span>
            </h1>
            <div className="container-xs">
              <p className="m-0 mb-32 reveal-from-bottom" data-reveal-delay="400">
                Enjoy playing fun games and contribute to make the world a better place! You even have the chance to cash out!
                </p>
              <div className="reveal-from-bottom" data-reveal-delay="600">
                <ButtonGroup>
                {/* {connectors.map((connector) =>
                connector.available() ? (
                  <Button tag="a" color="primary" wideMobile key={connector.id} onClick={() => connect(connector)}>
                    Connect {connector.name}                    
                    </Button>
                    ) : null
                    )} */}
                  {/* {!active ? (
                    <Button
                    tag="a"  
                    wideMobile
                    color="dark"
                    target="_blank"
                    round
                    onClick={onOpen}
                    >Connect to EVM Wallet
                    </Button>
                    ) : (
                      <Button onClick={disconnect}>Disconnect</Button>
                  )} */}
                  {/* {account} */}
                  {/* <SendCharity /> */}
                </ButtonGroup>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

Hero.propTypes = propTypes;
Hero.defaultProps = defaultProps;

export default Hero;