import { EditorView } from '@codemirror/view'
import { GraphicsWidget } from './graphics'
import { editFigureDataEffect } from '../../figure-modal'

export class EditableGraphicsWidget extends GraphicsWidget {
  setEditDispatcher(button: HTMLButtonElement, view: EditorView) {
    button.classList.toggle('hidden', !this.figureData)
    if (this.figureData) {
      button.onmousedown = event => {
        event.preventDefault()
        event.stopImmediatePropagation()
        view.dispatch({ effects: editFigureDataEffect.of(this.figureData) })
        window.dispatchEvent(new CustomEvent('figure-modal:open-modal'))
        return false
      }
    } else {
      button.onmousedown = null
    }
  }

  updateDOM(element: HTMLImageElement, view: EditorView): boolean {
    if (
      this.filePath === element.dataset.filepath &&
      element.dataset.width === String(this.figureData?.width?.toString())
    ) {
      // Figure remained the same, so just update the event listener on the button
      this.setEditDispatcher(
        element.querySelector('.ol-cm-graphics-edit-button')!,
        view
      )
      return true
    }
    this.destroyed = false
    element.classList.toggle('ol-cm-environment-centered', this.centered)
    this.renderGraphic(element, view)
    return true
  }

  createEditButton(view: EditorView) {
    const button = document.createElement('button')
    button.setAttribute('aria-label', view.state.phrase('edit_figure'))
    this.setEditDispatcher(button, view)
    button.classList.add('btn', 'btn-secondary', 'ol-cm-graphics-edit-button')
    const buttonLabel = document.createElement('span')
    buttonLabel.classList.add('fa', 'fa-pencil')
    button.append(buttonLabel)
    return button
  }

  renderGraphic(element: HTMLElement, view: EditorView) {
    super.renderGraphic(element, view)
    if (this.figureData) {
      const button = this.createEditButton(view)
      element.prepend(button)
    }
  }
}