﻿
//при записи с пометкой удаления помечаем на удаление все задачи по бизнес процессу
Процедура ПриЗаписи(Отказ)
	////Если Ссылка.ПометкаУдаления Тогда //при удалении бизнес-процесса удаляем задачи
	//	Запрос = Новый Запрос;
	//	Запрос.Текст = "ВЫБРАТЬ
	//				   |	Задача.Ссылка
	//				   |ИЗ
	//				   |	Справочник.Задача КАК Задача
	//				   |ГДЕ
	//				   |	Задача.Заявка = &Заявка";
	//	
	//	Запрос.УстановитьПараметр("Заявка", Ссылка);
	//	
	//	Результат = Запрос.Выполнить();
	//	Выборка = Результат.Выбрать();
	//	
	//	Пока Выборка.Следующий() Цикл
	//		ЗадачаОбъект = Выборка.Ссылка.ПолучитьОбъект();
	//		ЗадачаОбъект.ПометкаУдаления = ПометкаУдаления;
	//		ЗадачаОбъект.Записать();
	//	КонецЦикла;
	////КонецЕсли;
	
	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Стартован = Ложь;
	Завершен = Ложь;
	Гиперссылка = Неопределено;
	ГиперссылкаСтрока = "";
	Для каждого ТекИсполнитель Из СписокИсполнителей Цикл
		ТекИсполнитель.Исполнено = Ложь;	
		ТекИсполнитель.ДатаВыполнения = Ложь;
		ТекИсполнитель.Комментарии = "";
	КонецЦикла; 
	Документ = Неопределено;
	СтарыйСрок = Дата('00010101000000');
	НовыйСрок = Дата('00010101000000');
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Ссылка.Пустая() Тогда
		ДатаНачала = ТекущаяДата();
	КонецЕсли;
	Если Завершен Тогда
		ДатаЗавершения = ТекущаяДата();	
	КонецЕсли;
	
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры








