﻿
Процедура ПередЗаписью(Отказ)
	Если ПометкаУдаления И Общий Тогда
		Сообщить("Невозможно пометить на удаление общий маршрут.");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры
