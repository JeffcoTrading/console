import React, { Component } from 'react'
import { Modal, Button, Typography, Input } from 'antd';
const { Text } = Typography
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux'
import { removeDeviceFromLabels } from '../../actions/label'
import { displayError } from '../../util/messages'

@connect(null, mapDispatchToProps)
class RemoveLabelModal extends Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(e) {
    e.preventDefault();
    const { devicesToRemove, removeDeviceFromLabels, label, onClose } = this.props

    if (devicesToRemove.length === 0) displayError("No devices are selected for removal")
    else removeDeviceFromLabels(devicesToRemove, label.id)

    onClose()
  }

  render() {
    const { open, onClose, devicesToRemove } = this.props

    return (
      <Modal
        title="Remove Devices from Label"
        visible={open}
        onCancel={onClose}
        centered
        onOk={this.handleSubmit}
        footer={[
          <Button key="back" onClick={onClose}>
            Cancel
          </Button>,
          <Button key="submit" type="primary" onClick={this.handleSubmit} disabled={devicesToRemove.length === 0}>
            Submit
          </Button>,
        ]}
      >
        <div style={{ marginBottom: 20 }}>
          <Text>Are you sure you want to remove the following devices from this label?</Text>
        </div>
        {
          devicesToRemove.length == 0 ? (
            <div>
              <Text>&ndash; No Devices Currently Selected</Text>
            </div>
          ) : (
            devicesToRemove.map(d => (
              <div key={d.id}>
                <Text>&ndash; {d.name}</Text>
              </div>
            ))
          )
        }
      </Modal>
    )
  }
}

function mapDispatchToProps(dispatch) {
  return bindActionCreators({ removeDeviceFromLabels }, dispatch)
}

export default RemoveLabelModal
